# 练习3：CI 与"故意弄坏"验证

## 练习内容
配置 GitHub Actions 工作流，并故意弄坏代码验证 CI 能抓到问题。

## 实现
`.github/workflows/ci.yml` 两个 job：
- build-test：安装依赖 → cmake 配置 → 构建 → ctest
- quality：按 `BASE...HEAD` 计算变更的 C/C++ 文件，clang-format --dry-run --Werror + cppcheck src/（增量策略，与本地门禁一致；首次推送 SHA 全 0 时跳过）

## 故意破坏验证（本地模拟 CI）
1. 把 mining_layers.json 中 shallow 层解锁等级 1→99 → build 成功但 ctest 失败（数据破坏被测试抓到）
2. 给 object.h 插入错误缩进 → clang-format --dry-run --Werror 返回 1（格式破坏被抓到）
3. git restore 还原 → ctest 21/21 全绿

另：cppcheck 全量扫描 src/ 时发现 object.h 的 sellingPrice/buyingPrice 未初始化（默认构造后取值是未定义行为），修复并格式化后单独提交。

## 说明
actionlint 校验时报告 1 条 SC2086 info 提示（quality job 的 run 块内嵌 shell 未加引号防 globbing，shellcheck 风格建议，非错误）。本地 actionlint 仅作语法/结构校验，CI 实际运行不受影响；正式的门禁检查由 CI 内的 clang-format/cppcheck/shellcheck 步骤承担。

## 对应提交
- 1581024 fix(object): 初始化sellingPrice/buyingPrice成员并统一格式
- 6a9e4b3 feat(ci): 新增GitHub Actions工作流
