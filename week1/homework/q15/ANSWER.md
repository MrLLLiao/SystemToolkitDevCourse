# 练习15: git stash 工作流实验

## 实验步骤
1. 克隆/复制仓库，修改 README.md 添加一行
2. `git stash`：暂存未提交的修改，工作区恢复干净
3. `git log --all --oneline`：观察提交历史
4. `git stash pop`：恢复之前暂存的修改

## 结果
- **git stash 后**：工作区变干净，`git status` 无输出；修改被保存到 stash 栈中（`git stash list` 显示 `stash@{0}`）
- **git log --all --oneline**：提交历史**不包含** stash 的修改——stash 不产生新 commit（它创建的是 stash 对象，不在 `git log` 显示的常规提交历史中，但可通过 `git log --all --oneline --grep=WIP` 或 `git fsck` 找到）
- **git stash pop**：恢复工作区的修改，stash 从栈中弹出

## git log --all --oneline 看不到 stash 的原因
`git log` 默认只遍历提交（commit）的引用链。stash 本质是挂在 reflog 上的临时 commit，不属于任何分支的提交历史，所以 `git log --all --oneline` 不显示。`git log --all --oneline --graph --decorate` 会显示 `refs/stash`。

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
