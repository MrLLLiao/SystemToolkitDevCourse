# 练习9：pre-commit 钩子拒绝构建失败

## 练习内容
让 pre-commit 钩子在构建失败时拒绝提交（对应讲义"make paper.pdf 失败则不提交"）。

## 实现
练习1 已有 build+ctest 钩子，本次把钩子内部改为走练习7 的 Makefile（`make build && make test`），两处复用同一套构建入口（commit da08f6f）。

## 验证（见 output.txt）
往 object.cpp 追加一行语法错误后 `pre-commit run --files` 触发全部钩子：
1. cppcheck 报 syntaxError → Failed
2. build 钩子编译失败 → Failed
提交被拒绝。还原后通过。

## 踩坑
`git restore` 默认只还原工作树，暂存区仍保留坏版本，需 `git restore --source=HEAD --staged --worktree` 同时还原两侧。

## 对应提交
- da08f6f feat(toolchain): 构建门禁改用Makefile封装
