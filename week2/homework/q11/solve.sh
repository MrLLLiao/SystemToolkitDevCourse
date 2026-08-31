#!/usr/bin/env bash
# 练习11: dotfiles 项目演示——版本控制 + PS1 定制 + install.sh 安装 + 新机器模拟测试
set -u
cd "$(dirname "$0")"

echo "===== 1. dotfiles 目录内容 ====="
ls -la dotfiles
echo ""

echo "===== 2. 用全新 HOME 模拟新机器, 运行 install.sh ====="
FAKE_HOME=$(mktemp -d /tmp/fakehome.XXXXXX)
HOME="$FAKE_HOME" bash dotfiles/install.sh
echo ""

echo "===== 3. 验证新 HOME 下生成的符号链接 ====="
ls -la "$FAKE_HOME" | grep -E "\.(bashrc|bash_aliases|gitconfig|vimrc)"
echo ""

echo "===== 4. 验证 .bashrc 中的 PS1 定制 ====="
grep -n "PS1" dotfiles/.bashrc
echo ""

echo "===== 5. 验证别名文件内容 ====="
cat dotfiles/.bash_aliases
echo ""

echo "===== 6. 在子 shell 中 source 新 .bashrc, 确认 PS1 生效 ====="
( source "$FAKE_HOME/.bashrc"; echo "PS1 已设置为: $PS1" )
echo ""

echo "===== 7. 版本控制: 待提交文件与最终纳入跟踪 ====="
cd /root/gitRepo/SystemToolkitDevCourse
echo "-- 本练习新增文件(git status): --"
git status --short week2/homework/q11 | head -8
echo "-- 提交后 git ls-files 确认已跟踪: --"
git ls-files week2/homework/q11 | sort | head -8
rm -rf "$FAKE_HOME"
