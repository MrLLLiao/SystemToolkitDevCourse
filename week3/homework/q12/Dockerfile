# q12 隔离沙箱镜像：供编程智能体以 YOLO/自主模式在其中运行
# 设计参考 Claude Code devcontainers / Docker Sandboxes：容器即隔离边界
FROM python:3.12-slim

# 基础工具：git/curl 供智能体在沙箱内干活
RUN apt-get update && apt-get install -y --no-install-recommends \
        git curl ca-certificates procps \
    && rm -rf /var/lib/apt/lists/*

# 非 root 运行用户 + 可写工作区（命名卷将挂载于此）
RUN useradd -m -s /bin/bash agent \
    && mkdir -p /work/workdir \
    && chown -R agent:agent /work
USER agent
WORKDIR /work