#!/usr/bin/env python3
"""wordcount 模式2（AI 自动补全）版：completed —— 补全结果。

骨架保持不变，仅两处标记被自动补全填充：
① collect_words 函数体  ② --top 打印循环。补全基于"函数签名+docstring"的上下文。
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
    """把所有文件的词小写化后收集，供 --top 统计。"""
    out: list[str] = []
    for p in paths:
        with open(p, "rb") as f:
            text = f.read().decode("utf-8", errors="replace")
        out.extend(w.lower() for w in re.findall(r"[A-Za-z0-9]+", text))
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
        cols = "".join(f"{x:8d}" for x, on in zip(n, flags) if on)
        print(cols + (f" {path}" if len(args.files) > 1 else ""))
    if len(args.files) > 1:
        tcols = "".join(f"{x:8d}" for x, on in zip(total, flags) if on)
        print(f"{tcols} total")

    if args.top:
        print("--top 前 N 个高频词 --")
        for w, c in Counter(collect_words(args.files)).most_common(args.top):
            print(f"{c:5d}  {w}")
    return 0


if __name__ == "__main__":
    sys.exit(main())