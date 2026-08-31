#!/usr/bin/env bash
# 练习6: 信号与任务控制——挂起/后台/用 pgrep 找到 pid 后杀掉, 全程不手动输入 pid
set -u

echo "===== 1. 启动 sleep 10000 后台任务 ====="
sleep 10000 &
PID=$!
echo "shell 拿到的 pid=$PID"
COLUMNS=0 ps -o pid,stat,cmd -p "$PID" | tail -1
echo ""

echo "===== 2. 模拟 Ctrl-Z (SIGTSTP): 挂起任务 ====="
kill -STOP "$PID"
COLUMNS=0 ps -o pid,stat,cmd -p "$PID" | tail -1     # 状态 T 表示 stopped
echo ""

echo "===== 3. 模拟 bg (SIGCONT): 让任务在后台继续运行 ====="
kill -CONT "$PID"
COLUMNS=0 ps -o pid,stat,cmd -p "$PID" | tail -1     # 状态 S 表示恢复运行
echo ""

echo "===== 4. 用 pgrep -af 查找 pid, 不手动输入 ====="
pgrep -af "sleep 10000"
echo ""

echo "===== 5. 用 pgrep 结果直接 kill ====="
kill $(pgrep -f "sleep 10000")
sleep 0.3
echo ""

echo "===== 6. 验证: 进程应已消失 ====="
if pgrep -f "sleep 10000" > /dev/null; then
  echo "进程仍在 (kill 失败?)"
else
  echo "进程已终止, pgrep 无输出"
fi
