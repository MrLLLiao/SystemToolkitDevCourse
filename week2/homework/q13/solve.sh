#!/usr/bin/env bash
# 练习13: 用调试器(pdb)定位并修复归并排序缺陷
set -u
cd "$(dirname "$0")"

echo "===== 1. 运行带 bug 的 merge_sort 于测试向量 ====="
python3 merge_sort_buggy.py
echo "(期望 [1, 1, 2, 3, 4, 5, 6, 9], 实际输出错误)"
echo ""

echo "===== 2. 用 pdb 在 bug 行(第16行 result.append(right[i])) 下断点观察 ====="
python3 -m pdb debug_target.py <<'PDBIN'
break merge_sort_buggy.py:16
continue
p i
p j
p left
p right
p "else 分支即将执行: i=1 但 j=0, 却使用 right[i]"
next
p result
where
quit
PDBIN
echo ""

echo "===== 3. 更极端的复现: merge([1,3],[2]) 会越界 IndexError ====="
python3 <<'PYEOF' 2>&1 | tail -6
import merge_sort_buggy as ms
print(ms.merge([1, 3], [2]))
PYEOF
echo ""

echo "===== 4. 修复差异: right[i] -> right[j] ====="
diff merge_sort_buggy.py merge_sort_fixed.py
echo ""

echo "===== 5. 运行修复后的版本 ====="
python3 merge_sort_fixed.py
echo ""

echo "===== 6. 运行 pytest 验证 ====="
python3 -m pytest test_merge_sort.py -v 2>&1 | tail -12
