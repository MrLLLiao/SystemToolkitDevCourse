#!/usr/bin/env bash
# 练习3：actionlint 校验 + 本地模拟 CI 破坏验证
set -uo pipefail
cd /root/gitRepo/MudGame
LOG=/tmp/hw_q03_sim.log
: > "$LOG"

echo "===== 1) actionlint 校验 CI 工作流 ====="
actionlint --version
actionlint .github/workflows/ci.yml 2>&1 | head -5
echo "actionlint rc=$?（0=通过）"

echo ""
echo "===== 2) 故意弄坏数据：shallow 层解锁等级 1 -> 99 ====="
python3 - <<'PYEOF'
p = 'src/Data/Ore/mining_layers.json'
s = open(p, encoding='utf-8').read()
s = s.replace('"mining_level": 1', '"mining_level": 99', 1)
open(p, 'w', encoding='utf-8').write(s)
print('数据已改坏（写入 mining_level=99）')
PYEOF

echo "---- 模拟 CI：重建 + ctest ----"
cmake --build build -j8 >> "$LOG" 2>&1
echo "build rc=$?（预期 0，数据不影响编译）"
if ctest --test-dir build --output-on-failure >> "$LOG" 2>&1; then
  echo "ctest rc=0 —— CI 未抓到（失败）"
else
  echo "ctest rc=1 —— CI 抓到数据破坏（预期）"
fi
grep -E 'FAILED|Test #' "$LOG" | head -4

echo ""
echo "===== 3) 还原并确认 21/21 ====="
git restore src/Data/Ore/mining_layers.json
ctest --test-dir build 2>&1 | tail -2
echo "git status:"
git status --short
echo "（工作区干净，演示无残留污染）"
