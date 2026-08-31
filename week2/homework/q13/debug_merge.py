#!/usr/bin/env python3
"""用 pdb 批处理方式在 merge 函数下断点, 步进观察 i/j/left/right 的取值变化, 定位错误元素选择"""
import pdb
import merge_sort_buggy as ms

# 在 merge 函数入口设断点, runcall 直接以特定参数调用 merge 便于观察
p = pdb.Pdb()
p.set_break(ms.merge)
print("=== 用 pdb 调试 merge([1,3],[2]): else 分支触发时 i=1, right[i] 越界 ===")
try:
    p.runcall(ms.merge, [1, 3], [2])
except Exception as e:
    print("捕获异常:", type(e).__name__, e)
