#!/usr/bin/env bash
# 练习4: marco/polo 演示——用 source 加载函数定义后再调用
set -u
source ./marco.sh

echo "===== 1. 准备两个临时目录 A、B ====="
A=$(mktemp -d /tmp/marco_A.XXXXXX)
B=$(mktemp -d /tmp/marco_B.XXXXXX)
echo "A=$A"
echo "B=$B"
echo ""

echo "===== 2. 进入 A, 执行 marco 保存目录 ====="
cd "$A"
marco
echo ""

echo "===== 3. 切换到 B ====="
cd "$B"
echo "当前目录: $PWD"
echo ""

echo "===== 4. 执行 polo, 应回到 A ====="
polo
echo "回到: $PWD"
if [ "$PWD" = "$A" ]; then
  echo "验证通过: 成功回到 marco 时所在的目录"
else
  echo "验证失败"
fi

rm -rf "$A" "$B"
