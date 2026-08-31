# 练习4: Dockerfile + docker-compose.yml 运行 Python 应用与 Redis 缓存

## 练习要求
为简单 Python 应用写一个 Dockerfile；再写一个 docker-compose.yml，把应用和 Redis 缓存一起跑起来。

## 应用设计（q04/app.py）
一个极简 HTTP 服务（仅用标准库 `http.server` + `redis` 客户端）：每次访问 `/` 调用 Redis 的原子 `INCR` 把访问计数 +1 并返回 JSON。刻意设计：
- **配置与代码分离**：连接参数全部读环境变量（`APP_HOST/APP_PORT/REDIS_HOST/REDIS_PORT`），同一份镜像可通过配置部署到不同环境；
- **状态外置**：计数状态放在 Redis（缓存服务），而非应用进程内——这正是"把缓存/状态交给专门服务"的微服务思想。

## Dockerfile（q04/Dockerfile）
```dockerfile
FROM python:3.12-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py .
EXPOSE 5000
CMD ["python", "app.py"]
```
要点：
- 用 **slim** 变体（而非完整 python 镜像），体积更小、攻击面更小；
- **先 COPY requirements.txt 再装依赖，最后 COPY 代码**——利用层缓存：代码改动只重建最后一层，依赖层可复用（课程强调的"分层缓存"）；
- `--no-cache-dir` 避免缓存垃圾进镜像；
- `CMD` 用 exec 形式（数组），信号可正确传递。

## docker-compose.yml（q04/docker-compose.yml）
```yaml
services:
  web:
    build: .
    ports: ["5000:5000"]
    environment:
      - REDIS_HOST=cache      # Docker 内部 DNS 直接解析到 cache 服务
      - REDIS_PORT=6379
    depends_on: [cache]       # 先启动 cache
  cache:
    image: redis:7-alpine
    ports: ["6379:6379"]
    volumes: [redis_data:/data]   # 数据持久化卷
volumes:
  redis_data:
```
要点：
- 两个服务由 Compose 编排，自动创建共享网络；**web 用服务名 `cache` 作为主机名**访问 Redis（Docker 内置 DNS 解析），无需关心 IP；
- `depends_on` 声明启动顺序；
- 命名卷 `redis_data` 挂到 Redis 的 `/data`，容器删除后数据仍在（本练习清理时用 `down -v` 显式删卷）；
- `ports` 把 5000/6379 暴露到宿主，便于本地 curl 验证。

## 运行与验证（solve.sh 自动复现，见 output.txt）
1. `docker compose up -d --build` → `q04-web-1`（5000）、`q04-cache-1`（6379）双双 Up；
2. 连续 3 次 `curl http://localhost:5000/`：
   ```
   {"service": "q04-web", "visits": 2, "redis": "cache:6379"}
   {"service": "q04-web", "visits": 3, "redis": "cache:6379"}
   {"service": "q04-web", "visits": 4, "redis": "cache:6379"}
   ```
   计数逐次 +1 → 证明 **web 容器确实在写同一个 Redis**（应用与缓存跨容器协作成立）；
3. 从 cache 容器内反向验证：`redis-cli GET q04:visits` → `4`，`redis-cli PING` → `PONG`；
4. `docker compose down -v` 清理（网络、卷一并移除）。

> 注：本机网络特殊（构建容器内经 fake-IP DNS 拉包会失败，见 q03），因此额外放了
> `docker-compose.override.yml` 在构建期注入宿主代理 build-args。它不影响官方 compose 语义。

## 收获
- Dockerfile 分层缓存、slim 镜像、exec 形式 CMD 是"写好 Dockerfile"的基本功；
- Compose 是"多容器应用"的声明式编排：网络、DNS、依赖顺序、卷、端口一次声明；
- 用 `docker compose exec` 进到运行中容器执行命令，是验证多服务协作的高效手段；
- 配置走环境变量 + 服务名寻址，让同一镜像可在本地/测试/生产零代码改动部署。