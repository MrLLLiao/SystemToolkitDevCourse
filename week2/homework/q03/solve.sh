#!/usr/bin/env bash
# 练习3: 进程替换 <(command)——把命令输出当成文件, 配合 diff 比较 printenv 与 export
echo "===== 1. printenv 输出示例（前5行） ====="
printenv | head -5
echo ""
echo "===== 2. export 输出示例（前5行） ====="
export | head -5
echo ""
echo "===== 3. 进程替换展开后的\"文件\"路径 ====="
echo "echo <(echo hi) 输出: $(echo <(echo hi))   (一个 /dev/fd/N 伪文件)"
echo ""
echo "===== 4. diff <(printenv | sort) <(export | sort) 的实际差异 ====="
diff <(printenv | sort) <(export | sort) | head -40
echo ""
echo "===== 5. 差异总行数 ====="
diff <(printenv | sort) <(export | sort) | wc -l
