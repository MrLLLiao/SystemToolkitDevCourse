#!/usr/bin/env bash
# 练习12: 克隆仓库并可视化版本历史
set -e
REPO_DIR=/root/ms
if [ ! -d "$REPO_DIR/.git" ]; then
    git clone https://github.com/missing-semester/missing-semester "$REPO_DIR"
fi
cd "$REPO_DIR"
echo "===== 仓库基本信息 ====="
git remote -v
git branch -a
echo ""
echo "===== 提交总数 ====="
git rev-list --all --count
echo ""
echo "===== 版本历史图 (git log --all --graph --decorate --oneline) ====="
git log --all --graph --decorate --oneline
echo ""
echo "===== 简化图形 (最近30条) ====="
git log --all --graph --oneline -30
echo ""
echo "===== 当前分支最近的提交 ====="
git log --oneline -5
