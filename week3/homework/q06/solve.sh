#!/bin/bash
# q06: 本地构建/验证 GitHub Pages 网站 + 演示 gh-pages 分支发布机制
set -u
cd "$(dirname "$0")"
echo "############ 1. 网站文件 ############"
ls -la site/
echo ""
echo "############ 2. 本地起站并验证渲染 ############"
cd site
python3 -m http.server 8123 >/tmp/q06_http.log 2>&1 &
SRV=$!
sleep 1.5
code=$(curl -s -o /tmp/q06_index.html -w "%{http_code}" http://localhost:8123/)
echo ">>> GET / => HTTP $code"
echo "--- 页面关键内容 ---"
grep -o "<title>[^<]*</title>" /tmp/q06_index.html
grep -o "学号 [0-9]*" /tmp/q06_index.html
grep -c "GitHub Pages" /tmp/q06_index.html | sed 's/^/  提到 GitHub Pages 的次数: /'
kill $SRV 2>/dev/null
cd ..
echo ""
echo "############ 3. 演示发布到 gh-pages 分支 ############"
bash deploy.sh 2>&1
echo ""
echo "############ 4. 收尾检查 ############"
cd /root/gitRepo/SystemToolkitDevCourse
echo ">>> 当前分支: $(git branch --show-current)"
git status --short | head -5 || true