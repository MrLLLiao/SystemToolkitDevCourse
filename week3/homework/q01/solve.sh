#!/bin/bash
# q01: 保存环境 printenv -> 创建 venv -> 激活 -> 再次 printenv -> diff
# 考察: 激活前后环境差异、$PATH 变化、deactivate 是什么
set -u
cd "$(dirname "$0")"

echo "############ 1. 激活前保存环境 ############"
printenv > before.txt
echo "before.txt 行数: $(wc -l < before.txt)"

echo ""
echo "############ 2. 创建虚拟环境 ############"
rm -rf .venv
python3 -m venv .venv
echo "python 版本(激活前): $(python3 --version)"
echo "python 路径(激活前): $(which python3)"

echo ""
echo "############ 3. 激活虚拟环境 ############"
# shellcheck disable=SC1091
source .venv/bin/activate
echo "VIRTUAL_ENV=$VIRTUAL_ENV"
echo "python 路径(激活后): $(which python)"
echo "python 版本(激活后): $(python --version)"

echo ""
echo "############ 4. 激活后保存环境 ############"
printenv > after.txt
echo "after.txt 行数: $(wc -l < after.txt)"

echo ""
echo "############ 5. diff before.txt after.txt ############"
diff before.txt after.txt > diff.txt || true
echo "diff 行数: $(wc -l < diff.txt)"
echo "----------------------------------------"
cat diff.txt
echo "----------------------------------------"

echo ""
echo "############ 6. PATH 对比 ############"
echo "--- 激活前 PATH 前3段 ---"
grep '^PATH=' before.txt | tr ':' '\n' | head -3
echo "--- 激活后 PATH 前3段 ---"
grep '^PATH=' after.txt | tr ':' '\n' | head -3

echo ""
echo "############ 7. which deactivate ############"
which deactivate || echo "(which deactivate 找不到可执行文件)"
echo "--- type deactivate ---"
type deactivate
echo "--- declare -f deactivate (前 15 行) ---"
declare -f deactivate | head -15

echo ""
echo "############ 8. 退出 venv 前后 PATH 恢复 ############"
deactivate
echo "deactivate 后 python 路径: $(which python3)"
echo "deactivate 后 VIRTUAL_ENV: [${VIRTUAL_ENV:-未设置}]"
echo "diff 与之前是否一致: $(diff -q before.txt <(printenv) && echo 一致 || echo 有差异)"