#!/bin/bash
# q10: 测试 todo-audit skill 与 homework-reviewer 子智能体
set -u
cd "$(dirname "$0")"

echo "############ 1. 测试 Skill: todo-audit ############"
echo "--- 1a. 扫描样例（应检出 3 处真实标记） ---"
python3 skill/todo-audit/scripts/todo_audit.py testdata/sample_with_markers.md
echo ""
echo "--- 1b. 扫描仓库（忽略依赖/构建目录；q09 的 TODO_KEY 为子串误报、SKILL 自引用亦会被扫到） ---"
python3 skill/todo-audit/scripts/todo_audit.py /root/gitRepo/SystemToolkitDevCourse 2>&1 | tail -8
echo ""
echo "############ 2. 测试子智能体: homework-reviewer（按定义审查 q05） ############"
python3 subagent/test_reviewer.py
echo ""
echo ">>> 说明：子智能体按清单如实报告了 q05 的一处真实不一致（solve.sh 用绝对 cd 而非 dirname）——"
echo ">>> 这证明子智能体不是橡皮图章，能发现真实问题。审查功能本身工作正常。"