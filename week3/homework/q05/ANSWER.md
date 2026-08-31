# 练习5: 发布 Python 包到 TestPyPI + 构建 Docker 镜像推送到 ghcr.io

## 练习要求
把 Python 包发布到 TestPyPI（除非值得分享，否则不要发到正式 PyPI）；然后用该包构建 Docker 镜像并推送到 ghcr.io。

## 关于凭据的说明（重要）
真实发布 TestPyPI / ghcr.io 需要账号凭据（TestPyPI 的 `__token__`、GitHub 的 GH_TOKEN/登录态），本机当前未配置任何凭据，因此**不能真实上传到公网**。为完整执行该练习，我用**机制完全一致的本地等效环境**跑通了整条链路：
- **本地 PyPI 索引**（pypiserver 容器，:8080）等效 TestPyPI；
- **本地 Docker registry**（registry:2 容器，:5000）等效 ghcr.io；
- `twine upload` / `pip install --index-url` / `docker push` / `docker pull` 全部是原生命令，只是目标地址换成本地。
并给出换上真实 token 后即可原样执行的命令（见文末）。

## 包设计（q05pkg-25020007073，src 布局）
- 用 `click` 写了一个 `q05hello` 命令行：`q05hello <名字>` 打印问候；
- `pyproject.toml` 声明 `[project]` 元数据、`[project.scripts] q05hello = "q05pkg.cli:main"` 入口点、`[build-system]` setuptools；
- 名字带学号后缀（`-25020007073`），保证 TestPyPI 名称唯一。

## 执行过程（solve.sh 自动复现，见 output.txt）
### 1. 构建产物并校验
```
uv build            → dist/*.whl + dist/*.tar.gz
twine check dist/*  → PASSED ×2
```
`uv build` 一次生成 sdist 与 wheel；`twine check` 校验 README 渲染、元数据与文件名规范。

### 2. 发布到包索引（本地 pypiserver 等效 TestPyPI）
```bash
docker run -d --name local-pypi -p 8080:8080 pypiserver/pypiserver:latest run -P . -a .
twine upload --repository-url http://127.0.0.1:8080 --username test --password test dist/*
```
上传成功（wheel 4.0 kB、sdist 3.4 kB 均 100%）。随后**用全新 venv 从索引安装**：
```bash
pip install --index-url http://127.0.0.1:8080/simple q05pkg-25020007073
q05hello 本地索引   →  Hello, 本地索引!
```
证明"发布 → 被其他环境安装使用"闭环成立。

### 3. 用该包构建 Docker 镜像
```dockerfile
FROM python:3.12-slim
COPY dist/q05pkg_25020007073-0.1.0-py3-none-any.whl /tmp/
RUN pip install --no-cache-dir /tmp/q05pkg_25020007073-0.1.0-py3-none-any.whl
ENTRYPOINT ["q05hello"]
```
- 镜像 191MB；**入口直接就是包的 CLI**（`ENTRYPOINT ["q05hello"]`）；
- `docker run --rm q05pkg-25020007073:0.1.0 镜像内CLI` → `Hello, 镜像内CLI!`。
- 构建时通过 `--build-arg` 传入宿主代理（本机 fake-IP DNS 网络适配，同 q03/q04）。

### 4. 推送演示（本地 registry 等效 ghcr.io）
```bash
docker run -d --name local-registry -p 5000:5000 registry:2
docker tag q05pkg-25020007073:0.1.0 localhost:5000/q05pkg-25020007073:0.1.0
docker push localhost:5000/q05pkg-25020007073:0.1.0
docker pull localhost:5000/q05pkg-25020007073:0.1.0   # 拉回验证
docker run --rm localhost:5000/q05pkg-25020007073:0.1.0 从registry拉回 → Hello!
```
push 返回 digest（`sha256:e8bd…`），拉回后能正常运行 → 镜像分发闭环成立。

## 换上真实 token 后即可执行的真实命令
### 发布到 TestPyPI（需要 TestPyPI 账号 + API token）
```bash
# 1. 申请 token：https://test.pypi.org/manage/account/token/，然后把 token 配到 ~/.pypirc
cat >> ~/.pypirc <<'EOF'
[testpypi]
  username = __token__
  password = pypi-AgEIcHlwaS5vcmc…   # 替换为真实 token
EOF
# 2. 发布
twine upload --repository testpypi dist/*
# 3. 从 TestPyPI 安装验证
pip install --index-url https://test.pypi.org/simple/ q05pkg-25020007073
```
### 推送到 ghcr.io（需要 GitHub 登录态 / GH_TOKEN）
```bash
# 1. 登录（echo $GH_TOKEN | docker login ghcr.io -u MrLLLiao --password-stdin）
docker login ghcr.io -u MrLLLiao
# 2. 打 ghcr 标签并推送
docker tag q05pkg-25020007073:0.1.0 ghcr.io/mrllliao/q05pkg-25020007073:0.1.0
docker push ghcr.io/mrllliao/q05pkg-25020007073:0.1.0
```

## 收获
- **发布 = 把构建产物上传到"别人能拉取的地方"**：PyPI 是包分发通道，registry 是镜像分发通道；`twine`/`docker push` 只是客户端，换 repo-url 就能指向不同索引/仓库；
- `twine check` 是发布前的低成本自检（README 渲染、文件名、元数据）；
- 本地跑一个 pypiserver/registry，就能在离线或未授权环境下端到端验证整条发布流程，是 CI 之前的好习惯；
- Docker 镜像里"入口即包的 CLI"让镜像可执行性直接继承包定义，`ENTRYPOINT` 与 `CMD` 有本质区别（前者固定入口、后者提供默认参数）。

## 验证
- `output.txt` 记录了完整可复现流程；重跑 `bash solve.sh` 可复现（会重新构建、上传、push、拉回并清理）。
- 已确认：twine check 通过、从本地索引安装运行成功、镜像内 CLI 运行成功、push→pull→run 全链路成功、清理无残留容器/镜像。
## 真实发布记录（补充，2026-08-31）
在用户提供 GitHub 令牌后，完成**ghcr.io 真实推送**：
- `docker login ghcr.io -u MrLLLiao` 成功；
- `docker push ghcr.io/mrllliao/q05pkg-25020007073:0.1.0` 成功，digest `sha256:f644c18e…`（全层推送完成）；
- `docker pull ghcr.io/mrllliao/q05pkg-25020007073:0.1.0` 验证可拉取，`docker run` 输出 `Hello, World!`；
- 包页：https://github.com/users/MrLLLiao/packages/container/package/q05pkg-25020007073 （当前为 private）。
- 真实 push 前须先修本机 git 代理（`git config --global http.proxy http://172.26.224.1:7890`），否则连不上 github.com。
- TestPyPI 已用独立 token 完成**真实上传**：wheel + sdist 已发布至
  https://test.pypi.org/project/q05pkg-25020007073/0.1.0/ ；
- 全新 venv 中 \pip install --index-url https://test.pypi.org/simple/ q05pkg-25020007073\ 安装成功，
  \q05hello\ 运行输出 "Hello, World!"（exit 0），导入路径为安装的 wheel（site-packages/q05pkg/cli.py）；
- 教训：test.pypi.org 与 pypi.org 是两套独立账号体系，GitHub 令牌、pypi.org 令牌都不能用于 TestPyPI，
  必须用 test.pypi.org 单独签发的 API token。