# 练习2: Python 包(pyproject.toml) + 安装到 venv + lockfile

## 练习要求
创建一个带 `pyproject.toml` 的 Python 包，装进虚拟环境；生成 lockfile 并检查它。

## 包结构
```
week3/homework/q02/
├── pyproject.toml      # PEP 621 元数据 + [project.scripts] 入口 + PEP 517 构建后端
├── src/msgreet/        # src 布局
│   ├── __init__.py
│   └── cli.py          # 基于 typer 的 CLI: msgreet [NAME]
├── uv.lock             # uv 生成的 lockfile（可提交、可复现）
└── output.txt          # 完整实验输出
```

`pyproject.toml` 关键点：
```toml
[project]
name = "msgreet-25020007073"
version = "0.1.0"
dependencies = ["typer>=0.12"]          # 声明式依赖（版本区间）
[project.scripts]
msgreet = "msgreet.cli:main"            # 安装后生成可执行命令
[build-system]
requires = ["setuptools>=68"]           # PEP 517 构建后端
build-backend = "setuptools.build_meta"
[tool.setuptools.packages.find]
where = ["src"]                          # src 布局，避免把测试等误打包
```

## 步骤与结果（solve.sh 自动复现）
1. `python3 -m venv .venv` + `pip install -e .`（editable 安装）
   - `which msgreet` → `.venv/bin/msgreet`（venv 内，PATH 前置遮蔽，见 q01）
   - `msgreet World` → `Hello, World!`，包与 CLI 都可用
2. `uv lock` → `Resolved 9 packages`，生成 `uv.lock`（99 行）
3. 检查 `uv.lock`：见下
4. `uv tree` 展示依赖树：`msgreet → typer → {annotated-doc, rich→{markdown-it-py→mdurl, pygments}, shellingham}`
5. `uv sync --frozen` 严格按 lockfile 重建安装，`msgreet FrozenCheck` 正常 → 验证可复现

## lockfile 里有什么？（为什么它保证可复现）
`uv.lock` 头部与每个包的条目（见 output.txt 第 3 步）：
```
version = 1
revision = 3
requires-python = ">=3.11"

[[package]]
name = "annotated-doc"
version = "0.0.5"
source = { registry = "https://pypi.org/simple" }
sdist = { url = ".../annotated_doc-0.0.5.tar.gz", hash = "sha256:c7e5...", size = 10758, upload-time = "..." }
wheels = [ { url = ".../annotated_doc-0.0.5-py3-none-any.whl", hash = "sha256:117b...", size = 5302, ... } ]
```
- **精确版本**：每个依赖（含传递依赖）都固定到具体版本，如 `typer==0.27.2`，不再是一个区间；
- **来源与校验**：记录了 sdist/wheel 的下载 URL、`sha256` 哈希、文件大小——安装时可校验完整性，防止被篡改；
- **上传时间**：记录发布时刻，便于审计；
- **锁定的是"解析结果"**：`pyproject.toml` 写的是意图（`typer>=0.12`），`uv.lock` 写的是裁决（具体到 0.27.2）。同一份 lockfile + `uv sync --frozen` 在任意机器/时间都能装出一模一样的环境。

## 库 vs 应用：该不该 lock？
- **库（library）**：被他人 import，约束应放宽（用版本区间），避免与用户其它依赖冲突——所以库项目通常**不提交 lockfile**；
- **应用/服务（application）**：是依赖的最终消费者，追求可复现部署——应**精确固定并提交 lockfile**。
本练习的 `msgreet` 兼具两者，演示的是"应用侧"做法（提交 uv.lock）。

## 为什么用 uv 而不是 pip？
- `uv lock` / `uv tree` / `uv sync` 是原生项目级工作流，一条命令完成解析+锁定+安装，且解析器远比 pip 快（本次 `uv lock` 解析 9 个包，pip 安装阶段曾因 pypi 慢而超时重试，uv 则毫秒级完成解析）；
- 课程推荐：环境与依赖管理尽量用 `uv pip` / `uv lock`。

## 验证
- `output.txt` 保留完整输出；重跑 `bash solve.sh` 可完整复现（会重建 .venv 与 uv.lock）。
- 已用 `uv sync --frozen` 从 lockfile 独立重建安装并运行成功，证明 lockfile 自洽。