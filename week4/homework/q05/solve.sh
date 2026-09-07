#!/usr/bin/env bash
# 练习5：正则批量替换项目符号
set -uo pipefail
cd "$(dirname "$0")"

echo "===== 替换前（before.md） ====="
cat before.md

cp before.md after.md
perl -pi -e 's/^\- /\* /' after.md

echo ""
echo "===== 替换后（after.md） ====="
cat after.md

echo ""
echo "===== 验证 ====="
echo "残留 '- ' 行数: $(grep -cE '^\- ' after.md || true)（应为 0）"
echo "分隔线 '---' 行数: $(grep -cE '^---$' after.md)（应为 1，未误伤）"
echo "替换后 '* ' 行数: $(grep -cE '^\* ' after.md)（应为 4）"
