# 练习6: test -f 文件存在性检查脚本

## 脚本逻辑
```bash
if [ -f "$1" ]; then
    echo "文件存在"
else
    echo "文件不存在"
fi
```

## 常用条件表达式
| 表达式 | 含义 |
|--------|------|
| `[ -f file ]` | 存在且是普通文件 |
| `[ -d file ]` | 存在且是目录 |
| `[ -e file ]` | 存在（任何类型） |
| `[ -r file ]` | 存在且可读 |
| `[ -z "$var" ]` | 变量长度为0 |
| `[ "$a" = "$b" ]` | 字符串相等 |

## `[ ]` 与 `test`
- `[ -f file ]` 和 `test -f file` 完全等价
- `[` 是命令不是语法符号，内部必须有空格
- 变量要用双引号括起来防止空值和分词

参考: https://www.gnu.org/software/bash/manual/html_node/Bash-Conditional-Expressions.html
