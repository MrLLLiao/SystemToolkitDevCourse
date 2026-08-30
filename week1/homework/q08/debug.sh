#!/usr/bin/env bash
set -x
echo "开始计算"
a=10
b=20
sum=$((a + b))
echo "a + b = $sum"
if [ $sum -gt 15 ]; then
    echo "结果大于15"
else
    echo "结果不大于15"
fi
set +x
echo "调试结束"
