#!/usr/bin/env bash
# 练习3: 单引号、双引号、ANSI-C 引号区别
NAME="world"

echo "===== 双引号: 允许变量展开和命令替换 ====="
echo "Hello, $NAME! Today is $(date +%A)"

echo ""
echo "===== 单引号: 完全字面量，不展开任何内容 ====="
echo 'Hello, $NAME! Today is $(date +%A)'

echo ""
echo "===== ANSI-C 引号 $'...': 解释转义序列 ====="
echo $'line1\nline2\tindented\u2603'

echo ""
echo "===== 输出同时包含字面量 $ 、 ! 和换行符的字符串 ====="
echo 'Cost: $100! Discount: 50%
Buy now!'

echo ""
echo "===== 用 ANSI-C 引号输出含 $ ! 换行的字符串 ====="
echo $'Price: $9.99!\nLimited offer!'
