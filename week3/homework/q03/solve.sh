#!/bin/bash
# q03: 用 Docker Compose 本地构建并运行 Missing Semester 课程网站
set -u
export PATH="$HOME/.local/bin:$PATH"
REPO_DIR=/root/week3_hw/missing-semester
cd "$(dirname "$0")"

echo "############ 0. 前置：Docker 环境 ############"
docker --version
docker compose version

echo ""
echo "############ 1. 克隆 Missing Semester 仓库 ############"
if [ ! -d "$REPO_DIR/.git" ]; then
  git -c http.proxy= -c https.proxy= clone --depth 1 https://github.com/missing-semester/missing-semester.git "$REPO_DIR" 2>&1 | tail -1
else
  echo "仓库已存在: $REPO_DIR（跳过克隆）"
fi
echo "--- Dockerfile 与 compose 文件 ---"
ls -la "$REPO_DIR/Dockerfile" "$REPO_DIR/docker-compose.yml"

echo ""
echo "############ 2. 本机网络适配：docker-compose.override.yml ############"
cat > "$REPO_DIR/docker-compose.override.yml" <<'EOF'
services:
  server:
    build:
      dockerfile: Dockerfile
      context: .
      args:
        HTTP_PROXY: http://172.26.224.1:7890
        HTTPS_PROXY: http://172.26.224.1:7890
        NO_PROXY: localhost,127.0.0.1
EOF
echo "已写入（构建期通过 Windows 宿主代理拉取 alpine 包与 Ruby gems）"

echo ""
echo "############ 3. docker compose up -d --build ############"
cd "$REPO_DIR"
docker compose up -d --build 2>&1 | tail -6
docker compose ps

echo ""
echo "############ 4. 等待并验证网站 ############"
for i in $(seq 1 30); do
  code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://localhost:4000/ 2>/dev/null)
  [ "$code" = "200" ] && { echo ">>> HTTP 200（等待 ${i}s 后就绪）"; break; }
  sleep 1
done
curl -s -o /dev/null -w "GET / => %{http_code}\n" --max-time 5 http://localhost:4000/
echo "--- 首页正文片段 ---"
curl -s --max-time 5 http://localhost:4000/ | grep -oE "<h1[^>]*>[^<]*</h1>|<h2[^>]*>[^<]*</h2>" | head -3
echo "--- 首页标题 ---"
curl -s --max-time 5 http://localhost:4000/ | grep -oiE "<title[^>]*>[^<]*</title>" | head -1
echo "--- 课程相关链接 ---"
curl -s --max-time 5 http://localhost:4000/ | grep -oE 'href="[^"]*_2026[^"]*"' | head -3
echo "--- 容器日志 ---"
docker compose logs --tail 6 2>/dev/null | tail -6

echo ""
echo "############ 5. 停止并清理 ############"
docker compose down 2>&1 | tail -2