# 练习10: 为编程智能体创建并测试 AGENTS.md、Skill、子智能体

## 练习要求
为你选择的编程智能体创建并测试：①AGENTS.md（或等效文件）②一个 Skill ③一个子智能体；
并思考什么情况下用其中某一种而不是另一种。（所选智能体可能不支持某些功能，可跳过/换支持者。）

> 所选智能体：本环境的编程智能体（"我"，Doubao 系 coding agent，在 WSL 中操作此仓库）。
> 环境约束说明：本环境的委派模型（MainAgent→OrganizeAgent→Subagent）由框架管理，
> 无法由我在仓库里"新建一个真子智能体"；因此按练习允许的方式，把子智能体做成**可移植的定义文件**
> （Claude Code 式 frontmatter + 指令清单），并用脚本严格按其清单执行来测试其行为。

## ① AGENTS.md（仓库根，真实生效）
创建于仓库根 `AGENTS.md`——内容：项目结构、常用命令、**git 提交规范（分步提交、feat(homework-qNN)/docs 前缀、中文描述）**、
非显然约束（Docker 需宿主代理、不散落临时文件、发布需凭据）。
- **测试方式**：从创建起，我在本仓库的每一次 commit 都严格遵循它（`feat(homework-qNN): 中文`、分步提交、提交前 `git status --short`）；
  它已经真实地约束了本次作业的全部 10 个 commit。

## ② Skill：todo-audit
`skill/todo-audit/`：`SKILL.md`（name/description/用法/边界）+ `scripts/todo_audit.py`（可执行）。
功能：递归扫描代码库的 TODO/FIXME/HACK/XXX 标记，按文件:行号聚合，退出码 0/1/2 可接 CI。
- **测试**（见 output.txt）：
  - 扫描故意埋了 3 处标记的样例 → 精确检出 3 处，exit=1；
  - 扫描整个仓库 → 发现 21 处"匹配"，其中包含 3 个真实遗留标记（testdata）和若干**子串误报**
    （q09 的 `TODO_KEY` 常量、SKILL 自身文档里的 "TODO" 字样）——如实暴露了"纯文本扫描"的边界；
  - 首轮扫描曾把 `.venv/site-packages` 里第三方库的 1003 处标记也算进来 → **已给 skill 打补丁**：
    忽略 `.git/.venv/node_modules/__pycache__/dist/build` 等依赖/构建目录（这是测试驱动出的真实改进）。

## ③ 子智能体：homework-reviewer
`subagent/homework-reviewer.md`：frontmatter（name/description）+ 角色 + 输入 + 审查清单 + 输出格式 + 边界。
`subagent/test_reviewer.py`：按其清单对目标目录做只读审查（三件套/solve.sh 可复现/output.txt/ANSWER.md/无临时文件）。
- **测试**（审查 week3/homework/q05，见 output.txt）：7 项中 6 项 PASS，1 项 FAIL——
  **如实发现 q05 的 solve.sh 用绝对路径 cd 而非 `dirname "$0"`**。这正好证明子智能体**不是橡皮图章**，
  能按清单发现真实的不一致（虽然 q05 能跑，但可移植性约定确实没做到）。

## 什么时候用哪一种？（核心思考）
| 机制 | 作用对象 | 触发方式 | 什么时候选它 |
|---|---|---|---|
| **AGENTS.md** | 约束"任何进入该仓库的智能体"的行为 | 智能体每次开工自动读取 | 想让**所有** agent/工具在本项目里遵守同一套约定（提交规范、目录结构、环境坑）——"项目级宪法" |
| **Skill** | 把"一类可复用任务"封装成"名字+用法+脚本" | 用户/agent 按 description 命中后读取再调用 | 想让 agent **会做某类事**（扫 TODO、转格式、起服务）且过程可复现——"能力插件"；比把逻辑写死在 prompt 里更可维护、可测试 |
| **子智能体** | 把"一个专职角色"（含角色视角+固定流程）独立出来 | 主 agent 委派给它 | 想让一个**专门视角**反复干活（审查、写测试、安全扫描），并且和主 agent 的上下文隔离——"专职员工" |

一句话：**AGENTS.md 管"规矩"，Skill 管"本事"，子智能体管"专职角色"**。规矩要项目级、轻量；
能力要封装、可测；角色要隔离、专注。三者可以叠加：AGENTS.md 说"提交要过 review"，子智能体去当那个 reviewer，reviewer 干活时可能调用某个 Skill。

## 验证
- `output.txt`：skill 双场景测试 + 子智能体审查全记录；重跑 `bash solve.sh` 可复现。
- 已确认：skill 检出真实标记、能区分子串误报、可被测试驱动改进（venv 排除）；子智能体能发现真实问题。