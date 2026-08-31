#!/bin/bash
# q07: 同一功能用四种模式各做一次并比较（输出验证全部产物行为一致）
set -u
cd "$(dirname "$0")"
echo "############ 1. 基线冒烟测试 ############"
python3 wordcount/wordcount.py testdata/sample.txt
echo ""
echo "############ 2. 四种模式产物一致性验证（--top 4 应完全一致） ############"
for f in manual/wordcount_top.py autocomplete/completed.py inline_chat/wordcount_top.py agent/wordcount_top.py; do
  echo "--- $f ---"
  python3 "$f" --top 4 testdata/sample.txt
done
echo ""
echo "############ 3. 列过滤标志验证（-l/-w/-c 均生效） ############"
for f in manual/wordcount_top.py autocomplete/completed.py inline_chat/wordcount_top.py agent/wordcount_top.py; do
  printf "%s: " "$f"
  python3 "$f" -w testdata/sample.txt
done
echo ""
echo "############ 4. 产物文件清单 ############"
find . -type f | sort