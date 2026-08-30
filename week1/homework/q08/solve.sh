#!/usr/bin/env bash
echo "===== 运行带 set -x 的脚本 ====="
bash debug.sh
echo ""
echo "===== 对比: 不带 set -x 运行同样逻辑 ====="
bash -c 'a=10; b=20; sum=$((a+b)); echo "a+b=$sum"; [ $sum -gt 15 ] && echo "大于15"'
