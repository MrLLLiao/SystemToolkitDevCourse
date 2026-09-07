# 练习2：单元测试与 HTML 覆盖率

## 练习内容
为 C++ 项目生成 HTML 覆盖率报告，找出未覆盖代码并补充单元测试。

## 实现
- 独立构建目录 build-cov，编译选项加 `--coverage -O0 -g`
- `scripts/coverage.sh` 封装全套流程：ctest → lcov capture → extract（仅 `*/MudGame/src/*`）→ summary → genhtml，输出 coverage/index.html
- 坑：gcc 15 的 gcov 数据与 lcov 2.0 不兼容，capture 必须带 `--rc branch_coverage=1 --ignore-errors mismatch,inconsistent,unused`
- 补充两个测试文件：
  - `ore_lookup_test.cpp`：未知矿石/未知矿区抛 out_of_range、产出权重回退 0.0、requires_lighting 真假分支
  - `tool_upgrade_test.cpp`：Tool::upgrade 成功 +1、满级返回 false

## 验证结果
初值：行 86.4%（386/447）、函数 81.1%（73/90）、分支 52.4%（297/567）
终值：行 93.5%（418/447）、函数 91.1%（82/90）、分支 60.7%（344/567）

补的全是错误路径——未知矿石要抛异常、未知矿区权重要回退 0、工具满级后升级要返回 false，这些恰是运行中最容易崩的地方。

## 对应提交
- ff18905 feat(test): 补充矿石/矿区查询边界与工具升级测试，覆盖率提升至93.5%
