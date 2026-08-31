# 练习12: 克隆仓库并可视化版本历史

## 练习内容
1. 克隆 https://github.com/missing-semester/missing-semester
2. 用 `git log --graph` 将版本历史可视化为图

## 关键命令

| 命令 | 作用 |
|------|------|
| `git clone <url>` | 克隆远端仓库（含完整历史） |
| `git log --graph` | 以 ASCII 图显示分支和合并历史 |
| `git log --oneline` | 每条提交一行（hash+标题） |
| `git log --all` | 显示所有分支的提交 |
| `git log --decorate` | 在提交旁显示分支/标签引用 |
| `git rev-list --all --count` | 统计全部提交数 |

## 图形输出解读

```
* 49f676c Tweak text about license
* 19bcac2 Switch to `docker compose`
* 77b301d Remove duplicate "the"
*   fea9192 Merge branch 'oiahoon/docs/fix-uv-lock-example'
|\
| * 7343431 docs: fix uv lockfile Docker example
* | 853e0ea Merge branch 'tufailrizvi-debug/fixing_typo'
...
```

- `*` 表示一个提交
- `|` 垂直连接祖先提交
- `\` `/` 表示分支分叉与合并
- `*   ` 开头且下方有 `|\` 的是合并提交（merge commit，有多个父提交）

## 观察
- missing-semester 仓库包含多个分支（master、another-shuffle、beyond-the-code 等）
- 有大量合并提交，反映多人协作
- 历史可以回溯到 2019 年（初始提交）

参考: https://git-scm.com/book/en/v2/Git-Branching-Branch-Management
