FROM python:3.12-slim

# 从构建上下文复制已构建好的 wheel 并安装
COPY dist/q05pkg_25020007073-0.1.0-py3-none-any.whl /tmp/
RUN pip install --no-cache-dir /tmp/q05pkg_25020007073-0.1.0-py3-none-any.whl

# 该镜像的入口就是包的 CLI
ENTRYPOINT ["q05hello"]