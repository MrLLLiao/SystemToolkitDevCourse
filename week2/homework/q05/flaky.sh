#!/usr/bin/env bash
# 讲义提供的"很少失败"的脚本: 只有 n 恰好等于 42 时才失败
n=$(( RANDOM % 100 ))
if [[ n -eq 42 ]]; then
  echo "Something went wrong"
  >&2 echo "The error was using magic numbers"
  exit 1
fi
echo "Everything went according to plan"
