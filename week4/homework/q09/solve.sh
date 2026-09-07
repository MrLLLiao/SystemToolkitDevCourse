#!/usr/bin/env bash
# 练习9：pre-commit 钩子拒绝构建失败（真实演示 + 还原）
set -uo pipefail
cd /root/gitRepo/MudGame
F=src/Objects/src/object.cpp

echo "===== 1) 往 object.cpp 追加语法错误并暂存 ====="
echo 'int this_is_a_syntax_error( {' >> "$F"
git add "$F"
git diff --cached --stat | tail -1

echo ""
echo "===== 2) 运行 pre-commit 钩子（等同提交时触发） ====="
pre-commit run --files "$F" 2>&1 | grep -E 'Failed|passed|syntaxError|error:' | head -8

echo ""
echo "===== 3) 还原（工作树 + 暂存区） ====="
git restore --source=HEAD --staged --worktree "$F"
git status --short
echo "（工作区已还原干净）"
