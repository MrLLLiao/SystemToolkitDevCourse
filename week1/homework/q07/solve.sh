#!/usr/bin/env bash
echo "===== chmod前: ls -l demo.sh ====="
ls -l demo.sh
echo ""
echo "===== 尝试直接运行 ./demo.sh ====="
./demo.sh 2>&1 || echo "直接运行失败（权限不足），退出码: $?"
echo ""
echo "===== 用bash解释器运行（不需执行权限） ====="
bash demo.sh
echo ""
echo "===== 执行 chmod +x demo.sh ====="
chmod +x demo.sh
ls -l demo.sh
echo ""
echo "===== 再次直接运行 ./demo.sh ====="
./demo.sh
echo "运行成功，退出码: $?"
