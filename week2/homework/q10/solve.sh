#!/usr/bin/env bash
# 练习10: alias 纠错 + history 分析常用命令
set -u
shopt -s expand_aliases   # 在非交互脚本中启用 alias 展开

echo "===== 1. 创建 typo 纠正 alias dc='cd' ====="
alias dc='cd'
TESTDIR=$(mktemp -d /tmp/alias_test.XXXXXX)
dc "$TESTDIR"
echo "执行 dc $TESTDIR 后, PWD=$PWD"
if [ "$PWD" = "$TESTDIR" ]; then
  echo "验证通过: dc 等价于 cd"
else
  echo "验证失败"
fi
cd /
rm -rf "$TESTDIR"
echo ""

echo "===== 2. 为常用命令定义更短的 alias ====="
alias ll='ls -la'
alias gs='git status'
alias ga='git add'
alias py='python3'
alias gcm='git commit -m'
echo "alias ll='ls -la'"
echo "alias gs='git status'"
echo "alias ga='git add'"
echo "alias py='python3'"
echo "alias gcm='git commit -m'"
echo ""

echo "===== 3. 用模拟 history 运行 top10 常用命令分析 ====="
cat > /tmp/fake_history <<'HISTEOF'
ls
ls
ls
ls
ls -la
ls -la
ls -la
ls -la
cd /root
cd /root
cd /tmp
git status
git status
git status
git commit -m "wip"
python3 train.py
python3 train.py
vim README.md
vim config.py
mkdir build
mkdir data
rm -rf *.pyc
rm -rf build
grep -r TODO src
curl -O https://example.com/a.tar.gz
make -j4
ssh vm
HISTEOF
HISTFILE=/tmp/fake_history
history -r
echo "--- 管道: history | awk '{\$1=\"\";print substr(\$0,2)}' | sort | uniq -c | sort -n | tail -n 10 ---"
history | awk '{$1="";print substr($0,2)}' | sort | uniq -c | sort -n | tail -n 10
