#!/usr/bin/env bash
# 练习9: 递归找出目录中最近修改的文件, 并按"最近修改时间"列出所有文件
set -u
DEMO=$(mktemp -d /tmp/find_recent.XXXXXX)
trap 'rm -rf "$DEMO"' EXIT
cd "$DEMO"

# 构造目录树与不同修改时间的文件
mkdir -p src/docs
echo a > src/main.c
echo b > src/docs/readme.md
echo c > src/docs/notes.txt
echo d > root.log
echo e > src/old.c
touch -d "2026-08-01 09:00" src/main.c
touch -d "2026-08-20 10:00" src/docs/readme.md
touch -d "2026-08-25 11:00" src/docs/notes.txt
touch -d "2026-08-28 12:00" root.log
touch -d "2026-07-01 08:00" src/old.c

echo "===== 1. 目录结构 ====="
find . -type f | sort
echo ""

echo "===== 2. 递归找出最近修改的 1 个文件 ====="
find . -type f -printf '%T@ %p\n' | sort -rn | head -1 | awk '{print $2 "  (mtime_epoch="$1 ")"}'
echo ""

echo "===== 3. 最近修改的前 3 个文件 ====="
find . -type f -printf '%T@ %p\n' | sort -rn | head -3
echo ""

echo "===== 4. 按修改时间列出所有文件 (新→旧, 含人类可读时间) ====="
find . -type f -printf '%T+  %p\n' | sort -r
echo ""

echo "===== 5. find -printf 格式符说明 ====="
echo "%T@  修改时间的 epoch 秒数(适合排序) | %T+  人类可读时间 | %p  文件路径"
