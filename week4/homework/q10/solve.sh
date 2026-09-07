#!/usr/bin/env bash
# 练习10：shellcheck + GitHub Pages 验证
set -uo pipefail
cd /root/gitRepo/MudGame

echo "===== shellcheck 版本与脚本检查 ====="
shellcheck --version | head -2
echo ""
shellcheck -x scripts/*.sh && echo "ALL PASS（4 个脚本）"

echo ""
echo "===== actionlint 校验 Pages 工作流 ====="
actionlint .github/workflows/pages.yml 2>&1 | head -3
echo "actionlint rc=$?（0=通过）"

echo ""
echo "===== Pages 工作流与静态站点 ====="
echo "--- .github/workflows/pages.yml ---"
head -14 .github/workflows/pages.yml
echo ""
echo "--- docs/index.html 标题 ---"
grep -oE '<title>[^<]*</title>|<h1>[^<]*</h1>' docs/index.html | head -3
