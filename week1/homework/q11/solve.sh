#!/usr/bin/env bash
# 练习11: Git 数据模型与核心对象
set -e
DEMO=/tmp/gitmodel
rm -rf "$DEMO"
mkdir -p "$DEMO"
cd "$DEMO"
git init -q
echo "===== 创建文件并提交 ====="
echo "hello git" > greeting.txt
echo "line1" > notes.txt
git add greeting.txt notes.txt
git commit -q -m "first commit: add greeting and notes"
echo "提交完成"
echo ""
echo "===== 查看 HEAD 指向的 commit 对象 ====="
git rev-parse HEAD
COMMIT=$(git rev-parse HEAD)
echo "commit 对象 hash: $COMMIT"
echo "对象类型: $(git cat-file -t $COMMIT)"
echo ""
echo "===== 查看 commit 对象内容 (git cat-file -p) ====="
git cat-file -p "$COMMIT"
echo ""
echo "===== 获取 commit 指向的 tree ====="
TREE=$(git cat-file -p "$COMMIT" | awk '/^tree/ {print $2}')
echo "tree 对象 hash: $TREE"
echo "对象类型: $(git cat-file -t $TREE)"
echo ""
echo "===== 查看 tree 对象内容 ====="
git cat-file -p "$TREE"
echo ""
echo "===== 查看 blob 对象 ====="
BLOB=$(git cat-file -p "$TREE" | grep greeting | awk '{print $3}')
echo "greeting.txt 的 blob hash: $BLOB"
echo "对象类型: $(git cat-file -t $BLOB)"
echo "blob 内容: $(git cat-file -p $BLOB)"
echo ""
echo "===== 修改文件后再次提交，观察对象 ====="
echo "hello git updated" > greeting.txt
git add greeting.txt
git commit -q -m "second commit: update greeting"
git log --oneline --all
echo ""
echo "===== 每个 commit 有唯一的 hash（内容寻址） ====="
git rev-parse HEAD
git cat-file -p HEAD | head -3
