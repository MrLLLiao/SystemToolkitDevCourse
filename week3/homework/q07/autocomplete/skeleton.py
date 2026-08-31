#!/usr/bin/env python3
"""wordcount 模式2（AI 自动补全）版：skeleton —— 我手敲骨架，补全负责填函数体。

我只写：import、函数签名/返回类型、docstring、argparse 参数声明、
以及调用点的框架。函数体和循环体用标记占位，交给自动补全。
"""
import argparse
import re
import sys
from collections import Counter


def count_file(path: str) -> tuple[int, int, int]:
    with open(path, "rb") as f:
        data = f.read()
    text = data.decode("utf-8", errors="replace")
    lines = text.count("\n")
    words = len(text.split())
    chars = len(data)
    return lines, words, chars


def collect_words(paths: list[str]) -> list[str]:
    """把所有文件的词小写化后收集，供 --top 统计。

    >>> 提示：这里留给补全实现——遍历 paths，读文件、解码、
    >>> 用 re.findall(r"[A-Za-z0-9]+", text) 切词并 lower()，extend 进 out。
    """
    out: list[str] = []
    # >>> AI 自动补全从这里开始 <<<
    return out


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(prog="wordcount")
    ap.add_argument("files", nargs="+", help="要统计的文件")
    ap.add_argument("-l", action="store_true", help="只输出行数")
    ap.add_argument("-w", action="store_true", help="只输出词数")
    ap.add_argument("-c", action="store_true", help="只输出字节数")
    ap.add_argument("--top", type=int, metavar="N", help="额外打印出现次数最多的前 N 个词")
    args = ap.parse_args(argv)

    flags = [args.l, args.w, args.c]
    if not any(flags):
        flags = [True, True, True]

    total = [0, 0, 0]
    for path in args.files:
        try:
            n = count_file(path)
        except OSError as e:
            print(f"wordcount: {path}: {e.strerror}", file=sys.stderr)
            return 1
        total = [t + x for t, x in zip(total, n)]
        if len(args.files) > 1:
            print(f"{n[0]:8d} {n[1]:8d} {n[2]:8d} {path}")
        else:
            print(f"{n[0]:8d} {n[1]:8d} {n[2]:8d}")
    if len(args.files) > 1:
        print(f"{total[0]:8d} {total[1]:8d} {total[2]:8d} total")

    if args.top:
        print("--top 前 N 个高频词 --")
        # >>> AI 自动补全从这里开始（用 collect_words + Counter.most_common 打印）<<<
    return 0


if __name__ == "__main__":
    sys.exit(main())