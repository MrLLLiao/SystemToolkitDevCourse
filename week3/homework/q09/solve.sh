#!/bin/bash
# q09: 氛围编程产物验证（起站 + 结构/功能自检）
set -u
cd "$(dirname "$0")"
echo "############ 1. 本地起站并 curl 验证 ############"
python3 -m http.server 8124 >/tmp/q09_http.log 2>&1 &
SRV=$!
sleep 1.5
code=$(curl -s -o /tmp/q09_index.html -w "%{http_code}" http://localhost:8124/index.html)
echo ">>> GET /index.html => HTTP $code"
echo ">>> 文件大小: $(wc -c < /tmp/q09_index.html) 字节"
grep -o "<title>[^<]*</title>" /tmp/q09_index.html
kill $SRV 2>/dev/null
echo ""
echo "############ 2. 结构 + 关键功能点自检 ############"
python3 verify_app.py
echo ""
echo "############ 3. 产物文件 ############"
ls -la