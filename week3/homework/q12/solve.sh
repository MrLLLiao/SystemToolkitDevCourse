#!/bin/bash
# q12: 构建并运行 YOLO 隔离沙箱演示
set -u
cd "$(dirname "$0")"
echo "############ 1. 构建沙箱镜像 ############"
docker compose build 2>&1 | tail -3
echo ""
echo "############ 2. 运行沙箱（隔离边界验证） ############"
docker compose up --remove-orphans 2>&1 | grep -vE 'Network q12|Volume q12|Container q12|Creating|Attaching|running|^\[|^Container|^ - |^$' | tail -40
echo ""
echo "############ 3. 清理 ############"
docker compose down --volumes 2>&1 | sed 's/^/  /'