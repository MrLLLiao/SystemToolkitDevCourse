#!/usr/bin/env bash
# 练习13: 找出最后修改 README.md 的人
cd /tmp/ms
echo "===== README.md 的完整提交历史 ====="
git log --oneline -- README.md
echo ""
echo "===== 最后修改 README.md 的提交 (git log -1 -- README.md) ====="
git log -1 -- README.md
echo ""
echo "===== 简洁输出：hash + 作者 + 邮箱 + 日期 + 消息 ====="
git log -1 --format="commit: %h%n作者: %an <%ae>%n日期: %ad%n消息: %s" --date=iso -- README.md
