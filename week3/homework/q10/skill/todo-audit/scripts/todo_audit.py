#!/usr/bin/env python3
"""todo-audit: 扫描代码库中的 TODO/FIXME/HACK/XXX 遗留标记。

用法: todo_audit.py [路径] [--pattern 正则]
退出码: 0=无匹配; 1=有匹配; 2=参数错误
自动忽略: .git/.venv/venv/node_modules/__pycache__/dist/build/.eggs/.tox
"""
import argparse
import pathlib
import re
import sys

EXTS = {".py", ".sh", ".md", ".toml", ".yml", ".yaml", ".html", ".js", ".ts"}
SKIP_DIRS = {".git", ".venv", "venv", "node_modules", "__pycache__",
             "dist", "build", ".eggs", ".tox", ".mypy_cache", ".pytest_cache"}


def main() -> int:
    ap = argparse.ArgumentParser(prog="todo-audit")
    ap.add_argument("path", nargs="?", default=".", help="要扫描的路径（默认当前目录）")
    ap.add_argument("--pattern", default=r"TODO|FIXME|HACK|XXX", help="匹配正则")
    args = ap.parse_args()

    root = pathlib.Path(args.path)
    if not root.exists():
        print(f"todo-audit: 路径不存在: {root}", file=sys.stderr)
        return 2

    pat = re.compile(args.pattern)
    hits: list[tuple[str, int, str]] = []
    files = root.rglob("*") if root.is_dir() else [root]
    for p in files:
        if not p.is_file() or p.suffix not in EXTS:
            continue
        if any(part in SKIP_DIRS for part in p.parts):
            continue
        try:
            text = p.read_text(encoding="utf-8", errors="replace")
        except OSError:
            continue
        for ln, line in enumerate(text.splitlines(), 1):
            if pat.search(line):
                hits.append((str(p), ln, line.strip()))

    hits.sort(key=lambda h: (h[0], h[1]))
    for path, ln, line in hits:
        print(f"{path}:{ln}: {line}")
    print(f"--- 共 {len(hits)} 处标记（pattern: {args.pattern}，已忽略依赖/构建目录）---")
    return 1 if hits else 0


if __name__ == "__main__":
    sys.exit(main())