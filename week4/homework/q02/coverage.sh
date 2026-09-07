#!/usr/bin/env bash
# 生成 MudGame 单元测试覆盖率 HTML 报告（输出到 coverage/）。
# 用法：bash scripts/coverage.sh
set -euo pipefail
cd "$(dirname "$0")/.."

BUILD=build-cov
if [ ! -d "$BUILD" ]; then
  cmake -S . -B "$BUILD" -DCMAKE_CXX_FLAGS='--coverage -O0 -g'
fi
cmake --build "$BUILD" -j"$(nproc)" >/dev/null
ctest --test-dir "$BUILD" --output-on-failure

echo "=== lcov capture（忽略 GCC15 与 gcov 的已知兼容告警）==="
lcov --capture --directory "$BUILD" --output-file /tmp/coverage_raw.info \
  --rc branch_coverage=1 --quiet \
  --ignore-errors mismatch,inconsistent,unused 2>/dev/null || true
lcov --extract /tmp/coverage_raw.info '*/MudGame/src/*' \
  --output-file /tmp/coverage.info --rc branch_coverage=1 --quiet \
  --ignore-errors mismatch,inconsistent,unused 2>/dev/null || true

echo "=== 覆盖率汇总 ==="
lcov --summary /tmp/coverage.info --rc branch_coverage=1 --ignore-errors mismatch 2>&1 \
  | grep -E 'lines|functions|branches' | head -6

echo "=== genhtml -> coverage/ ==="
rm -rf coverage
genhtml /tmp/coverage.info --output-directory coverage --branch-coverage --quiet \
  --ignore-errors source 2>/dev/null || true
echo "报告已生成: coverage/index.html"
