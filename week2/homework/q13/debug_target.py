#!/usr/bin/env python3
"""供 pdb 聚焦调试的小目标: 直接调用 merge([1,3],[1,4]),
在 else 分支处会出现 i != j, 从而暴露"误用 right[i] 而非 right[j]"的缺陷。
"""
import merge_sort_buggy as ms

print("merge([1, 3], [1, 4]) =", ms.merge([1, 3], [1, 4]))
