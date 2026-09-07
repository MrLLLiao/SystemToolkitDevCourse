#!/usr/bin/env bash
# 练习11：proselint 文体检查演示
set -uo pipefail
cd /root/gitRepo/MudGame

echo "===== 说明 ====="
echo "proselint 是子命令式工具（proselint check <file>），无 --version 参数；空文件参数时读 stdin 卡死，Action 内须加空守卫"
echo "===== proselint check README.md ====="
proselint check README.md && echo "PASS（无文体问题）"

echo ""
echo "===== 自定义 Action 配置 ====="
cat .github/actions/proselint-check/action.yml

echo ""
echo "===== md-lint 工作流（增量检查变更 .md） ====="
cat .github/workflows/md-lint.yml
