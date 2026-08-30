# 练习4: 标准流重定向

## 三条标准流
| 流 | 文件描述符 | 说明 |
|----|-----------|------|
| stdin | 0 | 标准输入 |
| stdout | 1 | 标准输出 |
| stderr | 2 | 标准错误 |

## 重定向语法
| 语法 | 作用 |
|------|------|
| `> file` | stdout 写入 file（覆盖） |
| `2> file` | stderr 写入 file |
| `&> file` | stdout+stderr 写入 file（Bash特有） |
| `> file 2>&1` | stdout+stderr 写入 file（POSIX兼容） |

## 实验要点
- `ls /nonexistent /tmp` 同时产生 stdout（/tmp内容）和 stderr（/nonexistent不存在）
- 分别重定向: `> stdout.txt 2> stderr.txt`
- 合并重定向两种等价写法: `&> both.txt` 或 `> both.txt 2>&1`
- `2>&1` 中 `&1` 表示文件描述符1当前指向，顺序很重要

参考: https://www.gnu.org/software/bash/manual/html_node/Redirections.html
