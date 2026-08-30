# 练习9: 带当天日期的备份文件名

## 核心命令
```bash
cp notes.txt "notes_$(date +%Y-%m-%d).txt"
```

## 命令替换 $(...)
- `$(command)` 执行 command 并将其输出替换到命令行中
- `` `command` `` 是旧写法，`$(command)` 更推荐（可嵌套）
- `$(date +%Y-%m-%d)` 生成如 `2026-08-30` 的日期字符串

## date 格式符
| 格式 | 含义 | 示例 |
|------|------|------|
| `%Y` | 4位年份 | 2026 |
| `%m` | 2位月份 | 08 |
| `%d` | 2位日期 | 30 |
| `%H` | 小时（24制） | 17 |
| `%M` | 分钟 | 30 |
| `%S` | 秒 | 45 |
| `%F` | 等价 %Y-%m-%d | 2026-08-30 |

## 通用备份函数
```bash
backup() {
    local file="$1"
    local base="${file%.*}"
    local ext="${file##*.}"
    cp "$file" "${base}_$(date +%Y-%m-%d).${ext}"
}
```
- `${file%.*}` 去掉最后一个.及其后内容（取文件名主体）
- `${file##*.}` 去掉最后一个.及其前内容（取扩展名）

参考: https://www.gnu.org/software/bash/manual/html_node/Command-Substitution.html
