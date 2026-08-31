# 练习13: 谁最后修改了 README.md？

## 方法
`git log` 支持文件名作为参数，只显示影响该文件的提交：
```bash
git log --oneline -- README.md
```
`git log -1 -- README.md` 显示最后一个修改该文件的提交。

## 结果
在 missing-semester 仓库中，最后修改 README.md 的提交是：

| 字段 | 值 |
|------|-----|
| commit | `49f676c` |
| 作者 | Anish Athalye <me@anishathalye.com> |
| 日期 | 2026-04-25 |
| 消息 | Tweak text about license |

## 关键点
- `git log -- <file>` 过滤出所有影响该文件的提交
- `-1` 只显示最近一条（最后修改者）
- `--format` 自定义输出格式：%h hash, %an 作者名, %ae 作者邮箱, %ad 日期, %s 标题
- 文件路径在 `--` 之后，避免歧义（防止与分支/标签重名）

参考: https://git-scm.com/docs/git-log
