# 练习15: git stash 工作流实验

## 实验步骤
1. 复制 missing-semester 仓库，修改 README.md 添加一行
2. `git stash`：暂存未提交的修改，工作区恢复干净
3. `git log --all --oneline`：观察提交历史
4. `git stash pop`：恢复之前暂存的修改

## 结果（基于实际输出）
- **git stash 后**：工作区变干净，`git status` 无输出；修改被保存到 stash 栈中，提示 `Saved working directory and index state WIP on master: fea9192 ...`
- **git log --all --oneline**：**会**显示 stash 相关的两个临时提交：
  ```
  e9eec99 WIP on master: fea9192 Merge branch 'oiahoon/docs/fix-uv-lock-example'
  07f739e index on master: fea9192 Merge branch 'oiahoon/docs/fix-uv-lock-example'
  fea9192 Merge branch 'oiahoon/docs/fix-uv-lock-example'
  ...
  ```
  因为 `--all` 会遍历所有引用（含 `refs/stash`），所以 stash 的 WIP/index 提交也可见。若用不带 `--all` 的 `git log` 则看不到。
- **git stash list**：显示 `stash@{0}: WIP on master: ...`
- **git stash pop**：恢复工作区修改（` M README.md`），并输出 `Dropped refs/stash@{0}`，stash 从栈中弹出

## stash 的原理
- stash 把未提交的工作目录和暂存区修改打包成临时 commit，挂在 `refs/stash` 引用下
- 它不属于任何分支的常规历史，但可以通过 `--all`（遍历所有引用）或 `--grep=WIP` 看到
- 切换分支 / pull 时 stash 可以"随身携带"未提交修改

## stash 有什么用？
| 场景 | 说明 |
|------|------|
| 切换分支 | 工作做到一半，需要切到其他分支处理紧急问题，又不想丢失当前修改 |
| 拉取更新 | `git pull` 前有未提交修改，stash 后再 pull，避免冲突 |
| 测试干净基线 | 临时移除所有未提交修改，测试后再恢复 |

## 常用命令
| 命令 | 作用 |
|------|------|
| `git stash` | 暂存未提交修改 |
| `git stash list` | 查看 stash 栈 |
| `git stash pop` | 恢复最近一个 stash 并删除 |
| `git stash apply` | 恢复但保留 stash |
| `git stash drop` | 删除 stash |
| `git stash show -p` | 查看 stash 的 diff |

参考: https://git-scm.com/docs/git-stash
