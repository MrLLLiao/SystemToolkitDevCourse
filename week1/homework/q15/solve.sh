#!/usr/bin/env bash
# 练习15: git stash 工作流实验
set -e
# 使用已克隆的 missing-semester 仓库做实验（复制一份避免污染原仓库）
rm -rf /tmp/stashdemo
cp -r /tmp/ms /tmp/stashdemo
cd /tmp/stashdemo
echo "===== 实验前：工作区干净 ====="
git status --short
echo "(无输出表示干净)"
echo ""
echo "===== 1. 修改一个已有文件 (README.md) ====="
echo "# My local experiment" >> README.md
echo "修改后的 git status:"
git status --short
echo ""
echo "===== 2. 执行 git stash ====="
git stash
echo "stash 后 git status:"
git status --short
echo "(无输出表示工作区恢复干净)"
echo ""
echo "===== 3. 查看 git log --all --oneline ====="
git log --all --oneline -5
echo ""
echo "===== 4. 查看 stash 列表 ====="
git stash list
echo ""
echo "===== 5. 执行 git stash pop 恢复修改 ====="
git stash pop
echo "pop 后 git status:"
git status --short
echo ""
echo "===== 6. 确认修改还在 ====="
tail -1 README.md
