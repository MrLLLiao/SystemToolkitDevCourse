# 练习13: 用调试器定位并修复归并排序缺陷

## 练习要求
讲义给出的归并排序伪代码含一个 bug。用调试器（gdb/lldb/pdb/IDE）定位并修复它。
测试向量：`merge_sort([3, 1, 4, 1, 5, 9, 2, 6])` 应返回 `[1, 1, 2, 3, 4, 5, 6, 9]`。

## 缺陷定位（pdb 断点法）
本练习用 Python + pdb。伪代码中的 bug 在 merge 的 else 分支：**误用 `right[i]`，应为 `right[j]`**。

```python
else:
    result.append(right[i])   # BUG: 应为 right[j]
    j += 1
```

用聚焦小目标 `debug_target.py` 直接调用 `merge([1,3],[1,4])`，在 bug 行（第 16 行）下断点：

```
break merge_sort_buggy.py:16
continue
p i      # -> 1
p j      # -> 0   ← i 和 j 已经不同
p left   # -> [1, 3]
p right  # -> [1, 4]
next     # 执行 result.append(right[i]) = right[1] = 4
p result # -> [1, 4]   ← 错误地追加了 4, 正确应追加 right[0]=1
```

**证据链**：当 `i=1, j=0` 时进入 else 分支，代码却用 `right[i]`（`right[1]=4`）而正确元素是 `right[j]`（`right[0]=1`）——索引用错导致元素错选、顺序错乱。

更极端的复现：`merge([1,3],[2])` 中 i 走到 1 时 `right[i]` 直接越界抛 `IndexError`，进一步坐实 `right[i]` 是错误索引。

## 修复
```python
result.append(right[j])   # 正确
```

## 验证
- 修复后测试向量输出 `[1, 1, 2, 3, 4, 5, 6, 9]` ✓
- pytest 参数化用例全部通过（含空数组、单元素、逆序、含重复元素等边界），见 test_merge_sort.py 与 output.txt。

## 调试心得
- 先在疑似行设断点，再对比循环变量（i/j）与数组，能快速定位"用了哪个下标"这类缺陷。
- 构造能放大问题的输入（`[1,3]` vs `[1,4]`、`[1,3]` vs `[2]`）比直接调大数组更容易让 bug 现形。
