#!/usr/bin/env bash
# 练习16: 模拟并解决 merge conflict
set -e
DEMO=/tmp/conflict
rm -rf "$DEMO"
mkdir -p "$DEMO"
cd "$DEMO"
git init -q
git config user.name "demo"
git config user.email "demo@example.com"

echo "===== 1. 创建 recipe.txt 并提交 ====="
cat > recipe.txt << 'EOF'
Pancake Recipe
1 cup flour
1 cup sugar
1 cup milk
EOF
git add recipe.txt
git commit -q -m "Add pancake recipe"
echo "初始提交完成"

echo ""
echo "===== 2. 创建两个分支 salty 和 sweet ====="
git branch salty
git branch sweet
git branch

echo ""
echo "===== 3. 在 salty 分支修改 (sugar -> salt) ====="
git checkout -q salty
sed -i 's/1 cup sugar/1 cup salt/' recipe.txt
git add recipe.txt
git commit -q -m "Change sugar to salt (salty)"
echo "salty 提交完成"

echo ""
echo "===== 4. 在 sweet 分支修改 (1 cup -> 2 cups) ====="
git checkout -q sweet
sed -i 's/1 cup sugar/2 cups sugar/' recipe.txt
git add recipe.txt
git commit -q -m "Double the sugar (sweet)"
echo "sweet 提交完成"

echo ""
echo "===== 5. 回到 master 合并 salty ====="
git checkout -q master
git merge salty -m "Merge salty branch" 2>&1 || true
echo "recipe.txt 内容:"
cat recipe.txt

echo ""
echo "===== 6. 合并 sweet (预期冲突) ====="
git merge sweet 2>&1 || true
echo ""
echo "===== 7. 查看冲突标记的 recipe.txt ====="
cat recipe.txt
echo ""
echo "===== 8. 解决冲突：保留 sweet 版本 (2 cups sugar) ====="
cat > recipe.txt << 'EOF'
Pancake Recipe
1 cup flour
2 cups sugar
1 cup milk
EOF
git add recipe.txt
git commit -q -m "Resolve merge conflict: keep sweet version (2 cups sugar)"
echo "冲突解决完成"

echo ""
echo "===== 9. 可视化合并历史 ====="
git log --graph --oneline --all
echo ""
echo "===== 10. 最终 recipe.txt ====="
cat recipe.txt
