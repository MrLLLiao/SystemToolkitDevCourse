#!/usr/bin/env bash
# marco/polo: 保存并在之后恢复当前工作目录
# 用法: source marco.sh 后, 在任意目录执行 marco 保存, 之后执行 polo 回到该目录

marco() {
    # 把当前目录保存到环境变量, 便于在函数和子 shell 中传递
    export MARCO_DIR="$(pwd)"
    echo "marco: 已保存目录 $MARCO_DIR"
}

polo() {
    # 回到 marco 保存的目录
    if [ -z "${MARCO_DIR:-}" ]; then
        echo "polo: 还没有执行过 marco" >&2
        return 1
    fi
    cd "$MARCO_DIR"
    echo "polo: 已回到 $PWD"
}
