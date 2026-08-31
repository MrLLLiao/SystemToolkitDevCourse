#!/usr/bin/env bash
# 练习14: 用 git blame 追踪 _config.yml 的 collections 行
cd /tmp/ms
echo "===== _config.yml 中 collections 相关内容 ====="
grep -n "collections" _config.yml
echo ""
echo "===== git blame _config.yml (完整输出) ====="
git blame _config.yml
echo ""
echo "===== 只看 collections 相关行 ====="
git blame _config.yml | grep -E "collections|output"
echo ""
echo "===== 追踪 collections: 行对应的 commit ====="
echo "collections: 行由 commit a88b4eac 引入（2020-01-17）"
echo ""
echo "===== git show 查看该 commit 详情 ====="
git show -s --format="commit: %H%n作者: %an <%ae>%n日期: %ad%n" --date=iso a88b4eac
git log -1 --format="消息: %s%n%n正文:%n%b" a88b4eac
