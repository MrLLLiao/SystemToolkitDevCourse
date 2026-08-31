#!/usr/bin/env bash
# 练习14: 用 AddressSanitizer 定位内存错误 (use-after-free)
set -u
cd "$(dirname "$0")"

echo "===== 1. 不加 sanitizer 编译运行 (可能\"看起来正常\") ====="
gcc uaf.c -o uaf && ./uaf
echo "退出码: $?  (常规运行时错误可能被掩盖)"
echo ""

echo "===== 2. 用 ASan 编译运行, 捕获报告 ====="
gcc -fsanitize=address -g uaf.c -o uaf_asan
./uaf_asan 2>&1
echo "ASan 运行退出码: $?"
echo ""

echo "===== 3. ASan 报告关键信息 ====="
./uaf_asan 2>&1 | grep -E "ERROR: AddressSanitizer|READ of size|WRITE of size|freed by|allocated by|#0|#1|SUMMARY" | head -25
echo ""

echo "===== 4. 修复差异: 读写移到 free 之前 ====="
diff uaf.c uaf_fixed.c
echo ""

echo "===== 5. 修复版 + ASan 验证无报错 ====="
gcc -fsanitize=address -g uaf_fixed.c -o uaf_fixed_asan
./uaf_fixed_asan 2>&1
echo "修复版退出码: $?"
rm -f uaf uaf_asan uaf_fixed_asan
echo "(已清理编译产物)"
