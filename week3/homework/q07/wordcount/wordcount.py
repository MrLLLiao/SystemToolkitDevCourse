#!/usr/bin/env python3
"""wordcount: 简易 wc 风格命令行工具（q07 基线版）。

用法: python3 wordcount.py [-l] [-w] [-c] <file...>
默认（无标志）同时输出 行数/词数/字节数。
"""
import argparse
import sys


def count_file(path: str) -> tuple[int, int, int]:
    with open(path, "rb") as f:
        data = f.read()
    text = data.decode("utf-8", errors="replace")
    lines = text.count("\n")
    words = len(text.split())
    chars = len(data)
    return lines, words, chars


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(prog="wordcount")
    ap.add_argument("files", nargs="+", help="要统计的文件")
    ap.add_argument("-l", action="store_true", help="只输出行数")
    ap.add_argument("-w", action="store_true", help="只输出词数")
    ap.add_argument("-c", action="store_true", help="只输出字节数")
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
        cols = "".join(f"{x:8d}" for x, on in zip(n, flags) if on)
        print(cols + (f" {path}" if len(args.files) > 1 else ""))
    if len(args.files) > 1:
        tcols = "".join(f"{x:8d}" for x, on in zip(total, flags) if on)
        print(f"{tcols} total")
    return 0


if __name__ == "__main__":
    sys.exit(main())