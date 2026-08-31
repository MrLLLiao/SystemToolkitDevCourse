#!/usr/bin/env bash
# pidwait: 等待指定 pid 的进程结束
# 原理: kill -0 不真正发信号, 进程存在返回 0、不存在返回非 0;
#       用 sleep 轮询避免 while 空转耗尽 CPU。
pidwait() {
    local pid="${1:?需要提供一个 pid}"
    while kill -0 "$pid" 2>/dev/null; do
        sleep 1
    done
    echo "pid $pid 已结束"
}
