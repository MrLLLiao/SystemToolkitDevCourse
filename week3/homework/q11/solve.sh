#!/bin/bash
# q11: 用命令行工具（第一讲学到的 grep/sed/awk）完成"匹配 Markdown 无序列表项"的正则练习，
#      且刻意不直接编辑源文件（所有结果输出到 stdout/独立文件）。
set -u
cd "$(dirname "$0")"
SRC=sample.md
SUM_BEFORE=$(md5sum "$SRC" | cut -d' ' -f1)

echo "############ 0. 源文件（仅展示，不会被修改） ############"
cat -n "$SRC"

echo ""
echo "############ 1. 朴素正则：grep -P '^\s*[-*+]\s+' ############"
echo ">>> 匹配无序列表项（含行号）:"
grep -Pn '^\s*[-*+]\s+' "$SRC" || true
echo ""
echo ">>> 匹配数: $(grep -Pc '^\s*[-*+]\s+' "$SRC")  （含代码块内 2 行误报）"

echo ""
echo "############ 2. 排除代码块后的精确匹配：awk 维护围栏状态机 ############"
awk '/^```/{infence=!infence; next} !infence && /^[ \t]*[-*+][ \t]+/{print NR": "$0}' "$SRC"
echo ">>> 精确匹配数: $(awk '/^```/{infence=!infence; next} !infence && /^[ \t]*[-*+][ \t]+/{n++} END{print n+0}' "$SRC")"

echo ""
echo "############ 3. 负例验证（无序列表正则应不匹配它们） ############"
echo ">>> 有序列表行数（1. 2. 3.）: $(grep -Pc '^[0-9]+\.\s' "$SRC")"
echo ">>> 无序列表正则 对 有序列表行的匹配数（应 0）: $(grep -P '^[0-9]+\.' "$SRC" | grep -Pc '^\s*[-*+]\s+' || true)"
echo ">>> 水平线 '---' 行: $(grep -Pc '^---\s*$' "$SRC") 行；无序列表正则对其匹配数（应 0）: $(echo '---' | grep -Pc '^\s*[-*+]\s+' || true)"

echo ""
echo "############ 4. 提取列表项文本（sed 朴素版；与第 1 节一致含代码块误报） ############"
sed -n -E 's/^([ \t]*)[-*+][ \t]+/\1/p' "$SRC"
echo ">>> （若要干净提取，套用第 2 节的围栏状态机即可）"

echo ""
echo "############ 5. 验证源文件未被直接编辑 ############"
SUM_AFTER=$(md5sum "$SRC" | cut -d' ' -f1)
if [ "$SUM_BEFORE" = "$SUM_AFTER" ]; then
  echo ">>> md5 一致（$SUM_AFTER）：本次正则练习全程只读，未对源文件做任何直接编辑"
else
  echo ">>> !! md5 不一致，源文件被改了！"
fi
echo ">>> 全部结果均输出到 stdout/output.txt，源文件保持原样"
exit 0