#!/usr/bin/env bash
if [ -z "$1" ]; then
    echo "用法: $0 <文件名>" >&2
    exit 1
fi
if [ -f "$1" ]; then
    echo "文件 '$1' 存在，是一个普通文件。"
    echo "文件大小: $(wc -c < "$1") 字节"
    exit 0
else
    echo "文件 '$1' 不存在或不是普通文件。"
    exit 1
fi
