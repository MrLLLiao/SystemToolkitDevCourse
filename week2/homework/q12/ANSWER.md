# 练习12: tmux 终端复用器上手与基础定制

## 练习要求
跟着 tmux 入门指南上手（会话、窗口、面板），再按定制指南学习基础定制（~/.tmux.conf）。

## 1) 上手要点
| 概念 | 说明 | 常用命令/键 |
|------|------|--------------|
| 会话 session | 一组窗口，可 detach/attach | `tmux new -s name`、`tmux attach`、Ctrl-b d 分离 |
| 窗口 window | 会话内的标签页 | Ctrl-b c 新建、Ctrl-b n/p 切换 |
| 面板 pane | 窗口内的分屏 | Ctrl-b % 垂直分、Ctrl-b " 水平分、Ctrl-b 方向键切换 |

脚本中用非交互方式操作：`tmux new-session -d` 启动分离会话，`send-keys` 向面板发送按键，`capture-pane -p` 抓取屏幕内容验证命令真的执行了。

## 2) 基础定制（tmux.conf）
本目录 `tmux.conf` 对应 `~/.tmux.conf`，包含：

```tmux
set -g prefix C-a            # 前缀键 Ctrl-b -> Ctrl-a
unbind C-b
bind C-a send-prefix
set -g mouse on              # 启用鼠标
set -g base-index 1          # 窗口从 1 编号
set -g status-bg black       # 状态栏配色
set -g status-fg green
setw -g mode-keys vi         # 复制模式 vi 键位
```

加载方式：新开 tmux 自动读取 `~/.tmux.conf`；已运行时可 `Ctrl-b : source-file ~/.tmux.conf` 热加载。脚本用 `tmux -f ./tmux.conf new-session` 指定配置启动，再用 `show-options -g` 验证 prefix/mouse/base-index 等确实生效。

## 实测结果
output.txt：创建会话 demo → 两个窗口 → 第二个窗口水平分屏 → `capture-pane` 抓到面板里 `echo/pwd/ls` 的真实输出；随后用定制配置启动 demo2，`show-options` 确认 `prefix C-a`、`mouse on`、`base-index 1`、状态栏配色与 vi 键位全部生效。

## 参考
- 上手: https://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/
- 定制: https://www.hamvocke.com/blog/a-guide-to-customizing-your-tmux-conf/
