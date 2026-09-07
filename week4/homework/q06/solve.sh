#!/usr/bin/env bash
# 练习6：JSON 捕获 name——正则陷阱与解析器
set -uo pipefail
cd "$(dirname "$0")"

echo "===== 三种正则对比（转义引号样例） ====="
python3 - <<'PYEOF'
import re
s = '{"name": "say \\"hi\\"", "note": "含转义引号"}'
print("输入:", s)
print("贪婪     :", re.search(r'"name": "(.*)"', s).group(1))
print("懒惰     :", re.search(r'"name": "(.*?)"', s).group(1))
print("转义感知 :", re.search(r'"name": "((?:[^"\\]|\\.)*)"', s).group(1))
PYEOF

echo ""
echo "===== 命令行解析器 json_extract.py ====="
python3 json_extract.py data.json name

echo ""
echo "===== jq 对照 ====="
jq -r '.ore[].name' data.json
