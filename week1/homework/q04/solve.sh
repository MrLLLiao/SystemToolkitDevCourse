#!/usr/bin/env bash
echo "===== 原始输出: ls /nonexistent /tmp ====="
ls /nonexistent /tmp 2>&1 | head -5
echo "(...)"
echo ""
echo "===== stdout->stdout.txt, stderr->stderr.txt ====="
ls /nonexistent /tmp > stdout.txt 2> stderr.txt
echo "--- stdout.txt ---"
cat stdout.txt
echo "--- stderr.txt ---"
cat stderr.txt
echo ""
echo "===== 合并到同一文件 (&>) ====="
ls /nonexistent /tmp &> both.txt
cat both.txt
echo ""
echo "===== 合并到同一文件 (> file 2>&1) ====="
ls /nonexistent /tmp > both2.txt 2>&1
cat both2.txt
rm -f stdout.txt stderr.txt both.txt both2.txt
