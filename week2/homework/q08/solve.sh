#!/usr/bin/env bash
# 练习8: pidwait 函数演示——等待任意 pid 的进程结束
set -u
source ./pidwait.sh

echo "===== 1. 启动后台进程 sleep 3 ====="
sleep 3 &
PID=$!
echo "pid=$PID"
echo ""

echo "===== 2. 用 kill -0 检查进程是否还在 ====="
if kill -0 "$PID" 2>/dev/null; then
  echo "kill -0 返回 0: 进程存在"
else
  echo "kill -0 返回非 0: 进程不存在"
fi
echo ""

echo "===== 3. 调用 pidwait 等待其结束 ====="
T0=$(date +%s)
pidwait "$PID"
T1=$(date +%s)
echo "耗时: $((T1 - T0)) 秒"
echo ""

echo "===== 4. 验证进程已结束 ====="
if kill -0 "$PID" 2>/dev/null; then
  echo "进程仍在"
else
  echo "kill -0 返回非 0, 进程已结束"
fi
echo ""

echo "===== 5. 对不存在的 pid 调用 pidwait 应立即返回 ====="
T0=$(date +%s)
pidwait 999999
T1=$(date +%s)
echo "对不存在 pid 耗时: $((T1 - T0)) 秒 (说明立即识别并返回)"
