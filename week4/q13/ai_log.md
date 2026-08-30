# AI Log

**提示：** 修复 greetlab cli.py，当 --name 只含空白字符时 main 应以 SystemExit(2) 退出。约束：不改动参数解析逻辑，测试命令 `PYTHONPATH=src pytest test_cli.py`。

**智能体改动：** 在 main() 中 parse_args() 后添加 `if not a.name.strip(): raise SystemExit(2)`，共增加2行。

**人工验证：** diff 仅涉及 cli.py 第8-9行，无无关修改。pytest 2 passed，空白姓名测试通过。
