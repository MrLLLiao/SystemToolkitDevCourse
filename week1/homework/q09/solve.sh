#!/usr/bin/env bash
echo "===== 当前日期 ====="
date
echo ""
echo "===== 格式化日期: date +%Y-%m-%d ====="
date +%Y-%m-%d
echo ""
echo "===== 命令替换: $(date +%Y-%m-%d) ====="
echo "今天是: $(date +%Y-%m-%d)"
echo ""
echo "===== 备份文件: notes.txt -> notes_YYYY-MM-DD.txt ====="
cp notes.txt "notes_$(date +%Y-%m-%d).txt"
echo "备份完成，当前目录文件:"
ls -1
echo ""
echo "===== 验证备份内容 ====="
diff notes.txt "notes_$(date +%Y-%m-%d).txt" && echo "内容一致，备份成功"
echo ""
echo "===== 通用备份函数示例 ====="
backup() {
    local file="$1"
    local base="${file%.*}"
    local ext="${file##*.}"
    local backup="${base}_$(date +%Y-%m-%d).${ext}"
    cp "$file" "$backup"
    echo "已备份: $file -> $backup"
}
backup notes.txt
ls -1 notes*.txt
# 清理备份文件（保留原始notes.txt）
rm -f notes_*.txt
