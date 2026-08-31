#!/usr/bin/env python3
"""执行 homework-reviewer 子智能体的审查清单（q10 测试）。

子智能体定义见 subagent/homework-reviewer.md；本脚本按其清单对目标目录做只读审查。
"""
import pathlib
import sys

TARGET = pathlib.Path(sys.argv[1] if len(sys.argv) > 1 else "/root/gitRepo/SystemToolkitDevCourse/week3/homework/q05")

print(f"审查对象: {TARGET}")

def check(label, ok, detail=""):
    print(f"[{'PASS' if ok else 'FAIL'}] {label}: {detail}")
    return ok

results = []
# 1. 三件套
core = ["ANSWER.md", "solve.sh", "output.txt"]
for f in core:
    results.append(check(f"三件套 {f}", (TARGET / f).exists(), "存在" if (TARGET / f).exists() else "缺失"))
# 2. solve.sh 可复现
s = (TARGET / "solve.sh").read_text(encoding="utf-8") if (TARGET / "solve.sh").exists() else ""
results.append(check("solve.sh set -u", "set -u" in s))
results.append(check("solve.sh 用 dirname 定位", 'dirname "$0"' in s, "用绝对路径 cd 也能跑，但不如 dirname 稳健"))
# 3. output.txt 有结果
o = (TARGET / "output.txt").read_text(encoding="utf-8") if (TARGET / "output.txt").exists() else ""
results.append(check("output.txt 有内容", len(o) > 50, f"{len(o)} chars"))
# 4. ANSWER.md 完整
a = (TARGET / "ANSWER.md").read_text(encoding="utf-8") if (TARGET / "ANSWER.md").exists() else ""
missing = [k for k in ("练习", "执行", "验证") if k not in a]
results.append(check("ANSWER.md 含 练习/执行/验证", not missing, f"缺:{missing or '无'}"))
# 5. 无临时文件
junk = [x.name for x in TARGET.rglob("*") if x.suffix == ".tmp" or x.name.endswith("~") or x.name == ".gitkeep"]
results.append(check("无临时文件", not junk, junk or "无"))

print("结论: " + ("PASS" if all(results) else "需补充（详见上方 FAIL 项）"))
sys.exit(0 if all(results) else 1)