# 练习6: 信号与任务控制

## 练习要求
在终端启动 `sleep 10000`，用 Ctrl-Z 挂起，再用 `bg` 让它后台继续运行；然后用 `pgrep` 找到它的 pid，再用 `kill` 杀掉它。**整个过程不要手动输入 pid**（提示：用 `pgrep -af`）。

## 交互式终端的标准流程
```bash
$ sleep 10000
^Z                      # Ctrl-Z 发送 SIGTSTP, 任务挂起, 终端返回提示符
[1]+  Stopped   sleep 10000
$ bg                    # 发送 SIGCONT, 让任务在后台继续运行
[1]+ sleep 10000 &
$ pgrep -af "sleep 10000"   # -a 同时显示命令行, -f 匹配完整命令行
12345 sleep 10000
$ kill 12345            # 或用 $(pgrep -f ...) 直接取 pid
```

## 信号映射

| 操作 | 信号 | 效果 |
|------|------|------|
| Ctrl-Z | SIGTSTP | 挂起（暂停）任务，状态变为 `T`（Stopped） |
| `bg` | SIGCONT | 恢复被挂起的任务并在后台运行，状态变为 `S` |
| `kill <pid>` | SIGTERM | 请求进程终止 |

## 脚本化实现要点
非交互脚本里无法按键盘，因此用等价信号模拟：
- `kill -STOP $pid` 等价于 Ctrl-Z；
- `kill -CONT $pid` 等价于 `bg`；
- `ps -o pid,stat,cmd` 的 `STAT` 列可看到 `T`（stopped）与 `S`（sleeping）的变化。

```bash
sleep 10000 &
kill -STOP $PID
kill -CONT $PID
kill $(pgrep -f "sleep 10000")     # 全程未手动输入 pid
```

`pgrep -af "sleep 10000"` 中：`-f` 按完整命令行匹配（避免只匹配进程名），`-a` 同时列出 pid 与命令行，方便确认杀掉的是哪个进程。

## 实测结果
见 output.txt：任务启动 → `T`（挂起）→ `S`（恢复）→ pgrep 找到 pid → kill 后 pgrep 无输出，验证进程已终止。
