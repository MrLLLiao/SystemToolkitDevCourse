#!/usr/bin/env bash
# MudGame 本地质量门禁：对【暂存(staged)变更】执行
#   格式检查 -> 静态检查 -> 构建 -> 测试
# 全部通过返回 0，任一失败即非零退出。
# 说明：采用「增量采用」策略——只约束新改动，不回溯存量代码，
#       避免一次性全库格式化产生超大 diff。
set -euo pipefail
cd "$(dirname "$0")/.."

# 本次提交涉及的 C/C++ 文件
mapfile -t STAGED < <(git diff --cached --name-only --diff-filter=ACM | grep -E '\.(cpp|h|hpp)$' || true)

echo "=== [1/4] clang-format --dry-run --Werror (staged) ==="
if [ "${#STAGED[@]}" -gt 0 ]; then
  clang-format --dry-run --Werror "${STAGED[@]}"
fi
echo "format OK"

echo "=== [2/4] cppcheck (staged src/*.cpp) ==="
# 只分析生产代码 src/：cppcheck 对 gtest 宏存在已知解析缺陷，
# 测试代码由编译器 + 测试运行保障（见 scripts/hook_cppcheck.sh 注释）。
mapfile -t STAGED_CPP < <(printf '%s\n' "${STAGED[@]:-}" | grep '^src/.*\.cpp$' || true)
if [ "${#STAGED_CPP[@]}" -gt 0 ]; then
  INCLUDES=()
  while IFS= read -r d; do INCLUDES+=("-I" "$d"); done < <(find src tests -type d -name include)
  cppcheck --enable=warning,style,performance --std=c++20 \
    --suppressions-list=.cppcheck-suppressions \
    --error-exitcode=2 \
    "${INCLUDES[@]}" \
    "${STAGED_CPP[@]}"
fi
echo "cppcheck OK"

echo "=== [3/4] cmake --build ==="
cmake -S . -B build >/dev/null
cmake --build build -j"$(nproc)" >/dev/null

echo "=== [4/4] ctest ==="
ctest --test-dir build --output-on-failure

echo "=== 全部质量检查通过 ==="
