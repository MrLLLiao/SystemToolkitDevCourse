# 练习10: Aliases 与 history 分析

## 练习要求
1. 创建一个 alias `dc`，让你把 `cd` 打错时也能正常工作。
2. 运行 `history | awk '{$1="";print substr($0,2)}' | sort | uniq -c | sort -n | tail -n 10`，找出最常用的 10 条命令，并考虑给它们写更短的 alias。

## 1) typo 纠正 alias
```bash
alias dc='cd'
```
之后误输入 `dc /some/path` 也会像 `cd /some/path` 一样工作。要点：非交互脚本里需先 `shopt -s expand_aliases`，交互 shell 默认可用。演示脚本中 `dc <临时目录>` 后 `$PWD` 变为该目录，验证通过。

## 2) 更短 alias（对高频命令）
```bash
alias ll='ls -la'
alias gs='git status'
alias ga='git add'
alias py='python3'
alias gcm='git commit -m'
```

## 3) history top10 分析
命令逐段拆解：

| 管道段 | 作用 |
|--------|------|
| `history` | 输出形如 `  123  ls -la` 的编号+命令 |
| `awk '{$1="";print substr($0,2)}'` | 去掉第一列（编号），再去掉行首空格，只留命令文本 |
| `sort` | 排序（相同命令聚到一起） |
| `uniq -c` | 统计每条命令出现次数，输出 `次数 命令` |
| `sort -n` | 按次数数值升序 |
| `tail -n 10` | 取出现次数最多的 10 条 |

> 注：`history` 在非交互脚本中默认为空，演示用 `HISTFILE=/tmp/fake_history` + `history -r` 载入一份模拟历史后运行同一管道，得到频率 top10。

## 实测
模拟历史中最高频命令为 `ls`（4 次）、`ls -la`（4 次）、`cd`（3 次）等，正好对应上面定义的 `ll`、`gs`、`py` 等短别名——高频命令用短别名能显著减少打字量。

## 持久化
把 alias 写入 `~/.bashrc`（`alias dc='cd'` 等），每次打开新 shell 自动生效；这也为 q11 的 dotfiles 管理铺垫。
