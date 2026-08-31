#!/usr/bin/env python3
"""修复后的归并排序: merge 的 else 分支正确使用 right[j]。"""


def merge(left, right):
    result = []
    i = 0
    j = 0
    while i < len(left) and j < len(right):
        if left[i] <= right[j]:
            result.append(left[i])
            i += 1
        else:
            result.append(right[j])   # 修复: 原来误写成 right[i]
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
