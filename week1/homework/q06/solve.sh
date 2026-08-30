#!/usr/bin/env bash
echo "===== 测试1: 不存在的文件 ====="
bash check.sh nonexistent.txt
echo "退出码: $?"
echo ""
echo "===== 测试2: 存在的普通文件 ====="
echo "hello world" > sample.txt
bash check.sh sample.txt
echo "退出码: $?"
echo ""
echo "===== 测试3: 目录（不是普通文件） ====="
mkdir -p sampledi
bash check.sh sampledi
echo "退出码: $?"
echo ""
echo "===== 测试4: 无参数 ====="
bash check.sh
echo "退出码: $?"
rm -f sample.txt
rmdir sampledi
