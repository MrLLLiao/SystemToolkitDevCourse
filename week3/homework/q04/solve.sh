#!/bin/bash
# q04: Dockerfile + docker-compose.yml 运行 Python 应用与 Redis 缓存
set -u
export PATH="$HOME/.local/bin:$PATH"
cd "$(dirname "$0")"

echo "############ 0. 展示文件 ############"
echo "--- Dockerfile ---"
cat Dockerfile
echo ""
echo "--- docker-compose.yml ---"
cat docker-compose.yml

echo ""
echo "############ 1. docker compose up -d --build ############"
docker compose up -d --build 2>&1 | tail -8
docker compose ps

echo ""
echo "############ 2. 等待应用就绪并访问（验证计数递增） ############"
for i in $(seq 1 30); do
  code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://localhost:5000/ 2>/dev/null)
  [ "$code" = "200" ] && { echo ">>> 应用就绪（${i}s），HTTP $code"; break; }
  sleep 1
done
echo "--- 连续访问 3 次，观察 Redis 计数器递增 ---"
for i in 1 2 3; do
  curl -s --max-time 5 http://localhost:5000/; echo
  sleep 0.5
done

echo ""
echo "############ 3. 验证 Redis 中的数据（从 cache 容器内查） ############"
docker compose exec -T cache redis-cli GET q04:visits
docker compose exec -T cache redis-cli PING

echo ""
echo "############ 4. 服务连接关系 ############"
docker compose ps --format "table {{.Name}}\t{{.Service}}\t{{.Ports}}"

echo ""
echo "############ 5. 停止并清理 ############"
docker compose down -v 2>&1 | tail -3