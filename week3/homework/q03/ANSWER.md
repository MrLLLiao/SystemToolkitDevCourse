# 练习3: 安装 Docker 并用 Docker Compose 本地构建 Missing Semester 课程网站

## 练习要求
安装 Docker，用 docker compose 在本地构建并运行 Missing Semester 课程网站（https://missing.csail.mit.edu 的源码仓库 https://github.com/missing-semester/missing-semester）。

## 环境
- WSL Ubuntu 26.04（systemd 运行），`apt install docker.io docker-compose-v2` 安装 Docker 29.1.3 + Compose 2.40.3
- 仓库自带 `Dockerfile`（ruby:3.4-alpine3.21 + bundle install + jekyll serve）与 `docker-compose.yml`（端口 4000，挂载 ./ 到 /app）

## 仓库的 Dockerfile 与 compose 文件（未修改）
```dockerfile
# Dockerfile（官方）
FROM ruby:3.4-alpine3.21
RUN apk add --no-cache ruby-dev alpine-sdk
RUN mkdir /app
COPY Gemfile Gemfile.lock /app/
WORKDIR /app
RUN bundle install
CMD ["bundle", "exec", "jekyll", "serve", "-w", "--host", "0.0.0.0"]
```
```yaml
# docker-compose.yml（官方）
services:
  server:
    image: missing-semester:latest
    build: { dockerfile: Dockerfile, context: . }
    ports: ["4000:4000"]
    volumes: ["./:/app"]
    restart: on-failure
```

## 执行过程（solve.sh 自动复现）
1. `git clone --depth 1` 克隆 missing-semester 仓库
2. 写入 `docker-compose.override.yml`（本机网络适配，见下）
3. `docker compose up -d --build` —— 拉取基础镜像、apk 安装依赖、bundle install、启动 jekyll
4. `curl http://localhost:4000/` 验证 → **HTTP 200**，首页渲染出 "The Missing Semester of Your CS Education"（2026）
5. 查看容器日志：`Server address: http://0.0.0.0:4000`，`Server running...`
6. `docker compose down` 清理

## 本次遇到并解决的真实问题（网络适配，重点）
本机网络下直接构建遇到两类失败，做了两处适配：

### ① Docker Hub 拉镜像不稳 → 给 docker daemon 配 HTTP 代理
- 现象：`docker pull` 反复 `dial tcp ...:443: i/o timeout`（Docker Hub 直连间歇性不可达）。
- 排查：`curl` 探测发现**只有走 Windows 宿主代理 `172.26.224.1:7890` 才能稳定到达 docker.io**（返回 401 为正常未授权响应）。
- 解决：在 `/etc/systemd/system/docker.service.d/http-proxy.conf` 给 docker.service 配置 `HTTP_PROXY/HTTPS_PROXY` 指向该代理，`systemctl daemon-reload && systemctl restart docker`。此后 `docker pull` 稳定。

### ② 构建容器里 `apk add` 连不上 alpine 源 → 给构建传代理 build-args
- 现象：`RUN apk add --no-cache ruby-dev alpine-sdk` 反复 `WARNING: fetching ... temporary error (try again later)`。
- 排查过程（关键）：
  - `docker run alpine:3.21`（普通运行容器）直连 `dl-cdn.alpinelinux.org` 成功；但 `docker build`（无论 legacy 还是 BuildKit）内 apk 全部失败 → 运行容器与构建容器网络表现不同；
  - 进一步 `docker run ruby:3.4-alpine3.21` 内 `getent hosts` 发现 DNS 返回 **fake-IP（198.18.0.4/198.18.0.5）**——这是宿主侧 Clash 类代理的 fake-IP DNS 特征；wget 能通（busybox 不做证书校验），而 apk 走这条被拦截的 HTTPS 路由失败；
  - 试验证明：给容器显式注入代理 env（`HTTP_PROXY=http://172.26.224.1:7890`）后 `apk update` 立即成功（25397 个包可用）。
- 解决：在 compose override 的 `build.args` 里传入 `HTTP_PROXY/HTTPS_PROXY/NO_PROXY`，构建期 apk、bundle（Ruby gems）都走宿主代理，构建成功。

```yaml
# docker-compose.override.yml（仅本机网络适配，未改动仓库原文件）
services:
  server:
    build:
      dockerfile: Dockerfile
      context: .
      args:
        HTTP_PROXY: http://172.26.224.1:7890
        HTTPS_PROXY: http://172.26.224.1:7890
        NO_PROXY: localhost,127.0.0.1
```

### 为什么不直接改仓库 Dockerfile？
`docker-compose.override.yml` 是 Compose 自动合并的层，不改动第三方仓库的任何文件，可以干净地 `git pull` 升级，也便于把适配与官方文件区分开。

## 收获：容器 / Docker Compose 要点
- **image 是模板、container 是运行实例**；Dockerfile 每一条指令产生一层，Docker 按层缓存，改动只重建受影响层。
- Compose 用 YAML 声明多服务：`build` 定义构建、`ports` 做端口映射、`volumes` 做持久化/热更新、`restart` 设置重启策略；`docker compose up -d` 一条命令完成编排。
- **网络是容器最易踩坑的地方**：容器 DNS、宿主代理、镜像源可达性都可能因环境而异；用 `docker run` 小镜像 + `curl`/`getent` 做连通性探测，是快速定位"是网络问题还是配置问题"的通用手段。

## 验证
- 完整输出见 `output.txt`；重跑 `bash solve.sh` 可复现（仓库已克隆则跳过克隆）。
- 已确认：容器 Up、端口 4000 映射、HTTP 200、首页正确渲染 2026 课程内容、Jekyll 日志正常、`compose down` 清理干净。