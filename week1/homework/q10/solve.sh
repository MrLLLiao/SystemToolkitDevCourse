#!/usr/bin/env bash
echo "===== 测试目录中的文件 ====="
find scripts -type f | sort
echo ""
echo "===== 方法1: find + xargs（不处理空格，可能出错） ====="
find scripts -name '*.sh' | xargs wc -l
echo ""
echo "===== 方法2: find -print0 + xargs -0（正确处理空格） ====="
find scripts -name '*.sh' -print0 | xargs -0 wc -l
echo ""
echo "===== 对比: 含空格文件单独统计 ====="
wc -l "scripts/my script.sh"
echo ""
echo "===== 只统计.sh文件总行数 ====="
find scripts -name '*.sh' -print0 | xargs -0 wc -l | tail -1
echo ""
echo "===== xargs -n1 逐个文件统计 ====="
find scripts -name '*.sh' -print0 | xargs -0 -n1 wc -l
