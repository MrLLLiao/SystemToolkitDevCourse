#!/usr/bin/env bash
# 练习1：clang-format + cppcheck + pre-commit 门禁演示
set -uo pipefail
cd /root/gitRepo/MudGame

echo "===== 1) 工具版本 ====="
clang-format --version
cppcheck --version
pre-commit --version

echo ""
echo "===== 2) 门禁：staged C/C++ 文件 clang-format --dry-run --Werror ====="
STAGED=$(git diff --cached --name-only | grep -E '\.(cpp|h|hpp)$' || true)
if [ -z "$STAGED" ]; then
  echo "（当前无 staged C/C++ 文件，回溯最近 20 个提交取首个含 C/C++ 文件的提交演示）"
  for i in $(seq 0 19); do
    STAGED=$(git diff-tree --no-commit-id --name-only -r "HEAD~$i" | grep -E '\.(cpp|h|hpp)$' | head -3)
    [ -n "$STAGED" ] && break
  done
fi
echo "检查文件: $STAGED"
if [ -n "$STAGED" ]; then
  clang-format --dry-run --Werror $STAGED < /dev/null
  echo "clang-format rc=$? （0 表示格式合规）"
else
  echo "（示例提交不含 C/C++ 文件，格式检查跳过；生产门禁按 staged 文件生效）"
fi

echo ""
echo "===== 3) cppcheck 静态分析（生产代码 src/） ====="
cppcheck --quiet --enable=warning,performance,portability --suppressions-list=.cppcheck-suppressions -I src src/Model/Timeservice/src/time_service.cpp 2>&1 | head -12
echo "（输出为空=无告警；存量告警属增量采用策略可接受范围）"

echo ""
echo "===== 4) pre-commit 钩子配置 ====="
cat .pre-commit-config.yaml
