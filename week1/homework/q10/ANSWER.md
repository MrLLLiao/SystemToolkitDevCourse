# 练习10: xargs 与 find 配合统计 .sh 文件行数

## 核心命令
```bash
find . -name '*.sh' -print0 | xargs -0 wc -l
```

## 为什么需要 -print0 和 -0
- 默认 `find` 输出以换行符分隔文件名，`xargs` 以空白字符（空格、换行、制表符）分隔参数
- 如果文件名包含空格（如 `my script.sh`），默认方式会被拆成 `my` 和 `script.sh` 两个参数，导致错误
- `-print0` 让 find 以 null 字符（\0）分隔文件名
- `-0` 让 xargs 以 null 字符分隔输入
- null 字符不会出现在文件名中，因此能正确处理任意文件名（含空格、换行、特殊字符）

## 实验结果
- 方法1（无-print0/-0）: `my script.sh` 被拆分为两个参数，可能报错
- 方法2（-print0/-0）: 正确统计所有 .sh 文件行数
- `wc -l` 最后一行输出 total 总行数

## xargs 常用选项
| 选项 | 作用 |
|------|------|
| `-0` | 以null字符分隔输入（配合find -print0） |
| `-n N` | 每次命令最多传N个参数 |
| `-I {}` | 用{}占位符替换参数，可控制参数位置 |
| `-P N` | 并行执行N个命令 |

## 替代方案
```bash
find . -name '*.sh' -exec wc -l {} +   # -exec + 也能正确处理空格
```
但题目要求不用 find -exec，所以用 xargs。

参考: man xargs, man find
