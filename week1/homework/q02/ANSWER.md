# 练习2: glob 模式匹配

## 什么是 glob
glob 是 Shell 提供的文件名通配符匹配机制。Shell 在执行命令前，会将包含通配符的参数展开为匹配的文件名列表。常见模式：

| 模式 | 含义 |
|------|------|
| `*` | 匹配任意长度任意字符（不含前导`.`） |
| `?` | 匹配任意单个字符 |
| `[abc]` | 匹配方括号内任意一个字符 |
| `[a-z]` | 匹配范围内任意一个字符 |
| `{a,b,c}` | 花括号展开，生成 a, b, c（不是真正的glob，属于Brace Expansion） |

## 实验结果
- `*.txt` 匹配所有 .txt 后缀文件，包括 `my file.txt`（含空格）
- `file?.txt` 匹配 `file1.txt`, `file2.txt`, `fileA.txt`（? 只占一个字符位置）
- `{a,b,c}.txt` 展开为 `a.txt b.txt c.txt`，即使文件不存在也会展开（然后 ls 报错）
- `other.md` 不被 `*.txt` 匹配

## 注意
glob 由 Shell 展开，不是由命令（如 ls）处理。如果没有匹配项，默认行为取决于 Shell 设置（Bash 默认保留原字符串）。

## 参考
https://www.gnu.org/software/bash/manual/html_node/Pattern-Matching.html
