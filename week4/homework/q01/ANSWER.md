# 练习1：clang-format + cppcheck + pre-commit 质量门禁

## 练习内容
为 C++ 项目配置代码格式化工具、静态分析工具，并通过 pre-commit 钩子让不合格的改动无法提交。

## 实现
在 MudGame 仓库根目录新增三个配置：

- `.clang-format`：BasedOnStyle LLVM，缩进 4 空格，Allman 大括号（对齐仓库现有风格）
- `.cppcheck-suppressions`：文件级抑制 unusedFunction、missingIncludeSystem 等与项目无关的告警
- `.pre-commit-config.yaml`：三个 local 钩子
  1. clang-format：对暂存的 C/C++ 文件执行 `--dry-run --Werror`
  2. cppcheck：对暂存的 src/ 生产代码做静态分析（限定 src 是因为 cppcheck 2.19 对 gtest 宏有解析误报）
  3. build + ctest：增量构建并跑全部单元测试

## 关键取舍
全量扫描发现存量 1628 处格式违规。直接全库格式化会一次产生超大 diff，也破坏"分步提交"约束，因此采用**增量采用**策略：门禁只检查 staged 文件，存量问题逐步清理。对应 CI 中 quality job 也只查变更文件（见练习3）。

## 验证结果
见 output.txt。clang-format 对提交文件检查通过；cppcheck 报告均为存量可接受告警；pre-commit 钩子清单正确。练习期间钩子两次真实拦截：time_service.cpp 的 performance 建议、object.h 未初始化成员（后者在练习3 修复）。

## 对应提交（MudGame，本地未推送）
- d789ea9 feat(toolchain): 新增clang-format与cppcheck质量门禁及pre-commit钩子
- d8b79c3 feat(style): 应用clang-format统一时间服务模块风格
