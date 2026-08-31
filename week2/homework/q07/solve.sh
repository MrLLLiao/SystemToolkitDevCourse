#!/usr/bin/env bash
# 练习7: wait——不想在某个后台进程完成前启动另一进程
set -u
SLEEP_SECS=${SLEEP_SECS:-3}   # 讲义限制 sleep 60; 演示用 3 秒代替以节省时间, 机制完全相同

echo "===== 1. 启动后台任务: sleep $SLEEP_SECS & ====="
sleep "$SLEEP_SECS" &
PID=$!
echo "后台任务 pid=$PID"
echo ""

echo "===== 2. 说明: 若不 wait, ls 会立即执行, 与 sleep 并行 ====="
echo "(对比可自行把 wait 注释掉再跑一次)"
echo ""

echo "===== 3. wait \$PID 阻塞, 直到该后台任务结束 ====="
T0=$(date +%s)
wait "$PID"
WSTATUS=$?
T1=$(date +%s)
echo "wait 返回退出码: $WSTATUS (即后台任务的退出码)"
echo "等待耗时: $((T1 - T0)) 秒 (≈ sleep 时长, 说明 ls 确实等到了后台任务结束)"
echo ""

echo "===== 4. 等待结束后才执行 ls ====="
ls -la
echo ""

echo "===== 5. 对比: 不带参数 wait 会等待所有后台子进程 ====="
sleep 1 & sleep 2 &
T0=$(date +%s)
wait
T1=$(date +%s)
echo "不带参数 wait 耗时: $((T1 - T0)) 秒 (≈ 最慢的子任务 2 秒)"
