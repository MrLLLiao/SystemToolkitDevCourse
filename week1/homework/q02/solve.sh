#!/usr/bin/env bash
# 练习2: glob 模式匹配
set -e
TESTDIR="glob_test"
rm -rf "$TESTDIR"
mkdir -p "$TESTDIR"
cd "$TESTDIR"

# 创建测试文件
touch file1.txt file2.txt fileA.txt a.txt b.txt c.txt other.md "my file.txt"

echo "===== 所有文件 ====="
ls -1

echo ""
echo "===== ls *.txt (匹配所有 .txt 文件) ====="
ls -1 *.txt

echo ""
echo "===== ls file?.txt (? 匹配单个字符) ====="
ls -1 file?.txt

echo ""
echo "===== ls {a,b,c}.txt (花括号展开) ====="
ls -1 {a,b,c}.txt

echo ""
echo "===== ls *.txt 不匹配 other.md ====="
ls -1 other.md

cd ..
rm -rf "$TESTDIR"
