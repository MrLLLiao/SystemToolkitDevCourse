#!/usr/bin/env python3
"""命令行 JSON 键值提取工具（练习6：几行代码的 json 解析器）。

用法: python3 scripts/json_extract.py <json文件> <键名>
对文件内顶层对象/数组递归提取所有指定键的值并打印。
"""
import json
import sys

def extract(node, key):
    if isinstance(node, dict):
        if key in node:
            print(node[key])
        for v in node.values():
            extract(v, key)
    elif isinstance(node, list):
        for v in node:
            extract(v, key)

def main():
    if len(sys.argv) != 3:
        sys.exit(f"用法: {sys.argv[0]} <json文件> <键名>")
    with open(sys.argv[1], encoding="utf-8") as f:
        extract(json.load(f), sys.argv[2])

if __name__ == "__main__":
    main()
