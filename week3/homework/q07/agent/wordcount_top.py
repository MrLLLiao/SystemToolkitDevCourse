#!/usr/bin/env python3
"""wordcount 模式4（智能体）版：--top N 高频词统计（智能体端到端产出）。

智能体流程：读代码 → 计划（加纯函数+附加输出，不动旧逻辑）→ 实现 → 实测验证。
与模式1-3 的行为目标一致，但实现结构按"可复用/可测"组织（collect_words 独立成函数）。
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
    """把所有文件的词小写化后收集，供 --top 统计（独立纯函数，便于单测）。"""
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