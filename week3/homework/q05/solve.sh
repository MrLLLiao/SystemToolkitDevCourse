#!/bin/bash
set -u
export PATH="$HOME/.local/bin:$PATH"
cd /root/gitRepo/SystemToolkitDevCourse/week3/homework/q05
echo "############ 0. 构建包产物 ############"
rm -rf dist
uv build 2>&1 | tail -1
echo "############ 1. twine check（元数据校验） ############"
twine check dist/* 2>&1
echo "############ 2. 本地 PyPI 索引（等效 TestPyPI 演示） ############"
docker rm -f local-pypi >/dev/null 2>&1 || true
docker run -d --name local-pypi -p 8080:8080 pypiserver/pypiserver:latest run -P . -a . >/dev/null
sleep 3
echo "--- twine upload 到本地索引 ---"
twine upload --repository-url http://127.0.0.1:8080 --username test --password test dist/* 2>&1 | tail -3
echo "--- 从本地索引安装并运行 ---"
rm -rf /tmp/q05venv && python3 -m venv /tmp/q05venv
/tmp/q05venv/bin/pip install --quiet --index-url http://127.0.0.1:8080/simple q05pkg-25020007073
/tmp/q05venv/bin/q05hello 本地索引
echo "############ 3. 构建包含该包的 Docker 镜像 ############"
docker build --build-arg HTTP_PROXY=http://172.26.224.1:7890 --build-arg HTTPS_PROXY=http://172.26.224.1:7890 --build-arg NO_PROXY=localhost,127.0.0.1 -t q05pkg-25020007073:0.1.0 . 2>&1 | tail -3
docker images q05pkg-25020007073 --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"
echo "--- 运行镜像（入口即包的 CLI） ---"
docker run --rm q05pkg-25020007073:0.1.0 镜像内CLI
echo "############ 4. 推送演示：本地 registry 等效 ghcr.io ############"
docker rm -f local-registry >/dev/null 2>&1 || true
docker run -d --name local-registry -p 5000:5000 registry:2 >/dev/null
sleep 2
docker tag q05pkg-25020007073:0.1.0 localhost:5000/q05pkg-25020007073:0.1.0
echo "--- docker push localhost:5000/q05pkg-25020007073:0.1.0 ---"
docker push localhost:5000/q05pkg-25020007073:0.1.0 2>&1 | tail -3
echo "--- 从 registry 拉回验证 ---"
docker rmi -f localhost:5000/q05pkg-25020007073:0.1.0 >/dev/null 2>&1
docker pull localhost:5000/q05pkg-25020007073:0.1.0 2>&1 | tail -2
docker run --rm localhost:5000/q05pkg-25020007073:0.1.0 从registry拉回
echo "############ 5. 清理 ############"
docker rm -f local-pypi local-registry >/dev/null 2>&1 || true
docker rmi -f localhost:5000/q05pkg-25020007073:0.1.0 q05pkg-25020007073:0.1.0 >/dev/null 2>&1 || true
echo "cleaned"