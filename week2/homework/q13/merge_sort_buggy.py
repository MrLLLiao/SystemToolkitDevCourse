#!/usr/bin/env python3
"""带 bug 的归并排序: merge 的 else 分支误用 right[i] 而非 right[j]
用调试器(pdb)定位并修复。
"""


def merge(left, right):
    result = []
    i = 0
    j = 0
    while i < len(left) and j < len(right):
        if left[i] <= right[j]:
            result.append(left[i])
            i += 1
        else:
            result.append(right[i])   # BUG: 应改为 right[j]
            j += 1
    result.extend(left[i:])
    result.extend(right[j:])
    return result


def merge_sort(arr):
    if len(arr) <= 1:
        return arr
    mid = len(arr) // 2
    left = merge_sort(arr[:mid])
    right = merge_sort(arr[mid:])
    return merge(left, right)


if __name__ == "__main__":
    data = [3, 1, 4, 1, 5, 9, 2, 6]
    print("input :", data)
    print("output:", merge_sort(data))
