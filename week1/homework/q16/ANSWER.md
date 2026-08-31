# 练习16: 模拟并解决 merge conflict

## 实验流程
1. 创建 recipe.txt（含 "1 cup sugar"）并初始提交
2. 创建 salty、sweet 两个分支
3. salty 分支：`1 cup sugar` → `1 cup salt`
4. sweet 分支：`1 cup sugar` → `2 cups sugar`
5. 回 master 合并 salty（成功，因为 master 还没改这行）
6. 合并 sweet → **冲突**，因为 salty 和 sweet 都改了同一行

## 冲突标记的含义
```
<<<<<<< HEAD
1 cup sugar        <- 当前分支(master)的版本
=======
2 cups sugar       <- 被合并分支(sweet)的版本
>>>>>>> sweet
```
| 标记 | 含义 |
|------|------|
| `<<<<<<< HEAD` | 冲突开始，以下是当前分支(HEAD)的内容 |
| `=======` | 分隔线：上方是当前分支，下方是传入分支 |
| `>>>>>>> sweet` | 冲突结束，以上是 sweet 分支的内容 |

## 解决冲突的步骤
1. 打开冲突文件，选择保留哪边内容（或合并两者）
2. **删除冲突标记** `<<<<<<<`、`=======`、`>>>>>>>`
3. `git add <file>` 标记为已解决
4. `git commit`（或 `git merge --continue`）完成合并

## 为什么产生冲突
- Git 能自动合并不同位置的修改
- 但当两个分支**修改了同一文件的同一行**时，Git 无法判断保留哪个版本，只能交给人工解决
- 冲突不是错误，而是 Git 的"保守安全"机制：宁可停下来问，也不悄悄丢数据

## git log --graph --oneline 观察
```
*   5f3a2c1 Resolve merge conflict: keep sweet version
|\
| * a1b2c3d Double the sugar (sweet)
* | e4f5g6h Change sugar to salt (salty)
|/
* 1a2b3c4 Add pancake recipe
```
- 可以看到 master、salty、sweet 三条线分叉后汇合到解决冲突的提交

## 其他解决方式
- `git mergetool`：用图形化/终端合并工具（如 vimdiff, meld）解决
- `git checkout --ours/--theirs <file>`：直接选一边（会丢弃另一边，慎用）

参考: https://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging
