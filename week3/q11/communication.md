# Q11 协作材料改写

## Issue 重写

**标题：** sdt-greet --name " " 输出非空问候语且退出码为0

**环境：** Windows 11，Python 3.x，greetlab-25020007073 0.1.0

**复现命令：** `sdt-greet --name " "`

**期望结果：** 当 name 只含空白字符时，程序应以非零退出码退出，不输出问候语。

**实际结果：** 程序输出 `Hello, !` 并以退出码0结束。

**待确认：** 是否需要对 name 做 Unicode 空白字符（如全角空格）的处理。

## 提交信息重写

```
fix: reject whitespace-only name and exit with code 2

When --name contains only whitespace, the program previously printed
"Hello, !" and exited 0. Add validation in main() to detect blank
names, print an error message, and exit with SystemExit(2).
```

## 评审意见重写

**Blocking** — `cli.py:main()` 在 `name` 为纯空白时未做校验，导致输出无意义问候语且退出码为0，违反 CLI 约定（无效输入应非零退出）。

**风险：** 下游脚本可能依赖退出码判断成功/失败，当前行为会掩盖错误。

**建议动作：** 在 `parse_args()` 后增加 `name.strip()` 校验，若为空则 `raise SystemExit(2)`，并补充对应测试用例。
