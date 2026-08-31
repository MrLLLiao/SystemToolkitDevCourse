#!/usr/bin/env bash
# 练习12: tmux 终端复用器——上手(会话/窗口/面板/捕获) + 基础定制(.tmux.conf)
set -u

echo "===== 1. tmux 版本 ====="
tmux -V
echo ""

echo "===== 2. 启动分离会话 demo, 在其中执行命令 ====="
tmux kill-server 2>/dev/null
tmux new-session -d -s demo -x 120 -y 30
tmux send-keys -t demo 'echo "hello from tmux pane"' Enter
tmux send-keys -t demo 'pwd' Enter
tmux send-keys -t demo 'ls' Enter
sleep 0.5
echo ""

echo "===== 3. 新建第二个窗口并水平分屏 ====="
tmux new-window -t demo -n code
tmux split-window -t demo:1 -h
tmux send-keys -t demo:1.1 'echo "left pane: $(hostname)"' Enter
tmux send-keys -t demo:1.2 'echo "right pane"' Enter
sleep 0.5
echo ""

echo "===== 4. 会话/窗口/面板结构 ====="
tmux list-sessions
echo "---"
tmux list-windows -t demo
echo "---"
tmux list-panes -t demo
echo ""

echo "===== 5. 抓取窗口0的屏幕内容 (capture-pane) ====="
tmux capture-pane -t demo:0 -p | head -12
echo ""

echo "===== 6. 关闭 demo 会话, 演示定制配置 ====="
tmux kill-session -t demo
echo "已关闭 demo"
echo ""
echo "===== 7. 用本目录 tmux.conf 启动新会话, 验证定制生效 ====="
tmux -f ./tmux.conf new-session -d -s demo2 -x 120 -y 30
echo "prefix      = $(tmux show-options -g prefix)"
echo "mouse       = $(tmux show-options -g mouse)"
echo "base-index  = $(tmux show-options -g base-index)"
echo "status-bg   = $(tmux show-options -g status-bg)"
echo "mode-keys   = $(tmux show-window-options -g mode-keys)"
tmux kill-session -t demo2
echo ""
echo "===== 8. 清理, 确认无残留会话 ====="
tmux list-sessions 2>&1 || echo "(无会话, 清理完成)"
