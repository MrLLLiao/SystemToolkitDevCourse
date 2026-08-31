# AGENTS.md

本仓库是《系统开发工具基础》(Missing Semester 2026) 课程作业仓库，学生：廖世嘉（25020007073）。

## 项目结构
- `README.md`：按周记录课程结构与学习笔记。
- `weekN/homework/`：每周课后练习，每题一个目录 `qNN`；每个练习目录含
  `ANSWER.md`（解答与复盘）+ `solve.sh`（可复现验证脚本）+ `output.txt`（验证输出）。

## 常用命令
- 复现/验证某练习：`cd weekN/homework/qNN && bash solve.sh`（输出写入 output.txt）。
- 环境：WSL Ubuntu 26.04；Python 3.14、uv、docker + compose v2 已安装。
- 本机 Docker 构建容器需通过宿主代理 `172.26.224.1:7890`（见 week3/homework/q03/ANSWER.md）。

## git 提交规范（硬约束）
- 前缀：`feat(homework-qNN): ...` / `fix(homework-qNN): ...` / `docs: ...`，描述用中文。
- 每个练习单独、分步 commit；**禁止单次全量提交**。
- 完成后 `git status --short` 检查，保证工作区干净。

## 非显然约束
- 不向仓库根目录散落临时文件；临时产物放 `/root/week3_hw` 或 `/tmp`。
- 修改第三方仓库（如 missing-semester）时用 override/compose 覆盖层，不改其原文件。
- 需要对外发布/推送（GitHub push、TestPyPI、ghcr.io）时，本机缺少凭据，需用户提供 token 后执行。