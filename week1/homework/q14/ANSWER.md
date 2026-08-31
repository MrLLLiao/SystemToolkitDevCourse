# 练习14: 用 git blame 追踪 _config.yml 的 collections 行

## 方法
`git blame` 显示文件中每一行最后一次修改它的提交：
```bash
git blame _config.yml
```
输出格式：`commit-hash (作者 日期 行号) 代码内容`

## 结果
`_config.yml` 第 19 行 `collections:` 对应的 commit：

| 字段 | 值 |
|------|-----|
| commit | `a88b4eac` (a88b4eac326483e29bdac5ee0a39b180948ae7fc) |
| 作者 | Anish Athalye <me@anishathalye.com> |
| 日期 | 2020-01-17 15:26:30 -0500 |
| 提交消息 | **Redo lectures as a collection** |

## 分析
- blame 输出中 `^112ddbd` 表示初始提交（带 `^` 前缀）
- `collections:` 及 2019/2020 子行都由 `a88b4eac` 引入
- 后续 `2026` 子行由 `becf2000` 添加（2025-12-06），说明课程逐年扩展
- 这反映了一个 Jekyll 站点用 collection 组织历年讲义的演进

## 关键命令
| 命令 | 作用 |
|------|------|
| `git blame <file>` | 逐行显示最后修改的提交 |
| `git show -s <commit>` | 只显示提交元数据（不显示diff） |
| `git log -1 --format=%B <commit>` | 显示完整提交消息 |

参考: https://git-scm.com/docs/git-blame
