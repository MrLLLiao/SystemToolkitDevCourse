#!/usr/bin/env bash
# 练习2: 综合 ls 命令——隐藏文件 + 易读大小 + 按修改时间排序 + 彩色输出
set -u
DEMO=$(mktemp -d /tmp/ls_demo.XXXXXX)
trap 'rm -rf "$DEMO"' EXIT
cd "$DEMO"

# 生成不同大小、不同修改时间的测试文件
dd if=/dev/zero of=foo bs=1M count=5 2>/dev/null
dd if=/dev/zero of=baz bs=1M count=2 2>/dev/null
dd if=/dev/zero of=bar bs=1K count=100 2>/dev/null
dd if=/dev/zero of=.hidden bs=1K count=8 2>/dev/null
touch -d "2026-01-12 12:12" foo
touch -d "2026-01-14 06:42" bar
touch -d "2026-01-14 09:53" baz
touch -d "2026-01-14 10:30" .hidden

echo "===== 1. 普通 ls -l: 看不到隐藏文件, 大小为字节 ====="
ls -l

echo ""
echo "===== 2. 目标命令 ls -lah -t --color=always: 隐藏文件+易读大小+按时间+彩色 ====="
ls -lah -t --color=always

echo ""
echo "===== 3. 用 cat -v 展示彩色输出里实际注入的 ANSI 转义码 ====="
ls -lah -t --color=always | cat -v

echo ""
echo "===== 4. 各选项拆解 ====="
echo "-l  长格式 | -a  包含隐藏文件 | -h  易读大小(如 5.0M 而非 5242880)"
echo "-t  按修改时间倒序 | --color=always  强制输出 ANSI 彩色"
