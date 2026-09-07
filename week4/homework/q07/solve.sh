#!/usr/bin/env bash
# 练习7：Makefile 演示
set -uo pipefail
cd /root/gitRepo/MudGame

echo "===== Makefile 内容 ====="
cat Makefile

echo ""
echo "===== make list（源文件清单，前 3 行 + 总数） ====="
make list | head -3
echo "源文件总数: $(make list | wc -l)"

echo ""
echo "===== make build ====="
make build 2>&1 | tail -3

echo ""
echo "===== make test ====="
make test 2>&1 | tail -3
