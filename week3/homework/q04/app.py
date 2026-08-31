#!/usr/bin/env python3
"""q04 演示应用：一个带 Redis 缓存的简单 Python Web 服务。

每次访问 / 会调用 Redis 把计数器 +1 并返回 JSON，用于演示"应用 + 缓存服务"
两个容器通过 Docker 内部网络协作。配置全部来自环境变量（配置与代码分离）：
  APP_HOST / APP_PORT / REDIS_HOST / REDIS_PORT
"""
import json
import os
from http.server import BaseHTTPRequestHandler, HTTPServer

import redis

HOST = os.environ.get("APP_HOST", "0.0.0.0")
PORT = int(os.environ.get("APP_PORT", "5000"))
REDIS_HOST = os.environ.get("REDIS_HOST", "localhost")
REDIS_PORT = int(os.environ.get("REDIS_PORT", "6379"))

# 连接 Redis（Redis 里若没有 key，incr 会从 0 开始自增）
r = redis.Redis(host=REDIS_HOST, port=REDIS_PORT, decode_responses=True)


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path != "/":
            self.send_error(404)
            return
        # 用 Redis 原子自增做访问计数（体现"把状态放到缓存服务而不是应用进程内"）
        count = r.incr("q04:visits")
        body = json.dumps({
            "service": "q04-web",
            "visits": count,
            "redis": f"{REDIS_HOST}:{REDIS_PORT}",
        }, ensure_ascii=False).encode()
        self.send_response(200)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, fmt, *args):
        print(f"[app] {self.address_string()} - {fmt % args}", flush=True)


if __name__ == "__main__":
    print(f"[app] starting on {HOST}:{PORT}, redis={REDIS_HOST}:{REDIS_PORT}", flush=True)
    HTTPServer((HOST, PORT), Handler).serve_forever()