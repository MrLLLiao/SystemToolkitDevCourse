---
name: todo-audit
description: 扫描代码库（或指定路径）中的 TODO/FIXME/HACK/XXX 遗留标记，按文件聚合报告行号与原文，便于提交前清理待办或评估技术债。当用户说"找出所有 TODO"、"还有哪些没做完的标记"、"审计遗留标记/技术债"时使用。
---

# todo-audit

## 何时使用
- 用户想找出仓库里所有未完成的 TODO/FIXME/HACK/XXX 标记；
- 提交前想快速核查是否有遗留待办；
- 评估某模块的技术债分布。

## 用法
```bash
python3 scripts/todo_audit.py [路径] [--pattern PATTERN]
```
- `路径`：默认当前目录；递归扫描 `*.py *.sh *.md *.toml *.yml *.yaml *.html *.js`。
- `--pattern`：覆盖默认正则 `TODO|FIXME|HACK|XXX`。
- 退出码：0=无匹配；1=有匹配；2=参数错误。便于在 CI 里 `! todo_audit.py` 拦截遗留标记。

## 输出
按文件聚合，每行一条：`文件:行号: 原文`，结尾给出汇总统计。

## 边界
- 只做文本扫描，不做语义判断（例如 `# TODO` 与 `"TODO"` 字符串都会被匹配）；
- 默认忽略 `.git` 目录。