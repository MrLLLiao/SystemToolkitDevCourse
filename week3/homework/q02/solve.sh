#!/bin/bash
# q02: 创建 Python 包(pyproject.toml) -> 装进 venv -> 生成并检查 lockfile
set -u
cd "$(dirname "$0")"
export PATH="$HOME/.local/bin:$PATH"

echo "############ 1. 创建虚拟环境并安装本包 ############"
rm -rf .venv uv.lock
python3 -m venv .venv
# shellcheck disable=SC1091
source .venv/bin/activate
pip install -q -e .
echo "msgreet 可执行文件: $(which msgreet)"
echo "msgreet 模块路径:   $(python -c 'import msgreet, os; print(os.path.dirname(msgreet.__file__))')"

echo ""
echo "############ 2. 运行安装好的 CLI ############"
msgreet World
msgreet

echo ""
echo "############ 3. 用 uv lock 生成 lockfile ############"
uv lock 2>&1 | tail -3
echo "uv.lock 共 $(wc -l < uv.lock) 行"

echo ""
echo "############ 4. 检查 lockfile 头部 ############"
head -45 uv.lock

echo ""
echo "############ 5. uv tree: 依赖树 ############"
uv tree

echo ""
echo "############ 6. 从 lockfile 复现安装(uv sync --frozen) ############"
uv sync --frozen 2>&1 | tail -3
msgreet FrozenCheck