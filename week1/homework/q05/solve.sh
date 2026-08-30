#!/usr/bin/env bash
echo "===== 成功命令退出状态 ====="
ls /tmp > /dev/null
echo "ls /tmp 退出码: $?"
echo ""
echo "===== 失败命令退出状态 ====="
ls /nonexistent 2> /dev/null
echo "ls /nonexistent 退出码: $?"
echo ""
echo "===== && 仅前一条成功时执行 ====="
ls /tmp > /dev/null && echo "第一条成功，执行本条"
ls /nonexistent 2> /dev/null && echo "第一条失败，本条不执行"
echo ""
echo "===== || 仅前一条失败时执行 ====="
ls /nonexistent 2> /dev/null || echo "第一条失败，执行本条"
ls /tmp > /dev/null || echo "第一条成功，本条不执行"
echo ""
echo "===== 一行命令: 仅当/tmp/mydir不存在时创建 ====="
ls -d /tmp/mydir 2>/dev/null || echo "/tmp/mydir 不存在"
[ -d /tmp/mydir ] || mkdir /tmp/mydi
ls -d /tmp/mydi
echo "再次运行（已存在，不重复创建）:"
[ -d /tmp/mydir ] || mkdir /tmp/mydi
echo "退出码: $?"
rmdir /tmp/mydi
