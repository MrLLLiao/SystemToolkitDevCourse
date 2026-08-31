#!/usr/bin/env bash
# 练习15: 用 strace 追踪系统调用
set -u
cd "$(dirname "$0")"

echo "===== 1. strace -c ls -l: 系统调用次数汇总 ====="
strace -c ls -l 2>&1 | head -30
echo ""

echo "===== 2. 追踪 ls 打开的文件 (openat/open/access) ====="
strace -e trace=openat,open,access ls -l /etc/hostname 2>&1 | grep -E "openat|access" | head -12
echo ""

echo "===== 3. 追踪 echo 写标准输出的 write 调用 ====="
strace -e trace=write echo "hello strace" 2>&1 | head -8
echo ""

echo "===== 4. 追踪更复杂的程序: python3 启动时打开哪些文件 ====="
strace -e trace=openat python3 -c "print('hi from python')" 2>&1 | head -18
echo ""
echo "(python 启动会打开解释器、动态库、编码表等文件, 可见 openat 路径)"
