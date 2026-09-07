# 练习11：自定义 GitHub Action 对 .md 跑 proselint

## 练习内容
写一个自定义复合 Action，对仓库 markdown 文件运行 proselint 并报告文体违规，在 .md 变更时触发。

## 实现
- `.github/actions/proselint-check/action.yml`：composite action，安装 proselint 后对传入文件执行 `proselint check $FILES`，含空文件守卫
- `.github/workflows/md-lint.yml`：`git diff --name-only BASE...HEAD -- '*.md'` 计算本次变更的 .md（增量策略，与 CI 其他检查一致），再调用该 Action

## 结果
proselint 对 README.md 报告 4 处 `...` 应为 `…` 的标点问题（typography.symbols.ellipsis），修复后通过。

## 坑
proselint check 无参数时会读 stdin 卡死，Action 与本地脚本都必须先判断文件列表为空则跳过。

## 对应提交
- ae2682e fix(doc): 修正README省略号标点（proselint报告）
- d55253d feat(ci): 自定义proselint复合Action与md-lint工作流
- 10e3774 feat(ci): 自定义proselint Action仅检查变更md文件（增量策略）
