#!/usr/bin/env bash
# 练习1: ls -l 长格式与权限位
echo "===== ls -l / 输出 ====="
ls -l /
echo ""
echo "===== ls -l 本目录 ====="
ls -l
echo ""
echo "===== stat 查看单个文件权限 ====="
touch demo_file.txt
ls -l demo_file.txt
rm -f demo_file.txt
