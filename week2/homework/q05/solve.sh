#!/usr/bin/env bash
# 练习5: 返回码——不断运行 flaky.sh 直到它失败, stdout/stderr 分别存文件, 统计运行次数
cd "$(dirname "$0")"

count=0
: > stdout.log          # 清空/创建标准输出日志
: > stderr.log          # 清空/创建标准错误日志

while true; do
  count=$((count + 1))
  bash flaky.sh >> stdout.log 2>> stderr.log   # 分别追加保存两类输出
  status=$?
  if [ $status -ne 0 ]; then
    break
  fi
done

echo "共运行 $count 次, 第 $count 次失败 (退出码 $status)"
echo ""
echo "===== 标准输出 stdout.log ====="
cat stdout.log
echo ""
echo "===== 标准错误 stderr.log ====="
cat stderr.log
echo ""
echo "===== 验证: 成功的运行次数 = $((count - 1)), 失败 1 次 ====="
echo "stdout 总行数: $(wc -l < stdout.log) | stderr 总行数: $(wc -l < stderr.log)"
