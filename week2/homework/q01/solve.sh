#!/usr/bin/env bash
# 练习1: `--` 特殊参数——创建和删除以 "-" 开头的文件
# 说明: `--` 告诉程序"后面不再解析选项", 之后内容都按位置参数处理

echo "===== 1. 不带 -- 直接 touch -myfile（会被当作选项解析而报错） ====="
touch -myfile
echo "退出码: $?"
echo ""

echo "===== 2. touch -- -myfile 正常创建名为 -myfile 的文件 ====="
touch -- -myfile
ls -l ./-myfile
echo ""

echo "===== 3. 不使用 -- 删除它: 用 ./ 前缀把文件名变成路径 ====="
rm ./-myfile
if [ -e ./-myfile ]; then
  echo "删除失败, 文件仍存在"
else
  echo "删除成功, -myfile 已不存在"
fi
echo ""

echo "===== 4. 对比: rm -myfile 不带 -- 会再次报错 ====="
touch -- -myfile
rm -myfile
echo "退出码: $?（非 0, 说明 rm 把它当选项拒绝了）"
echo ""
echo "===== 5. 最后用 -- 清理 ====="
rm -- -myfile
echo "清理完成, 当前目录文件:"
ls -la
