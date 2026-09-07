#!/usr/bin/env bash
# 练习4：正则 vs semgrep 实测
set -uo pipefail
cd "$(dirname "$0")"

echo "===== demo.py 内容 ====="
cat demo.py

echo ""
echo "===== 正则1（讲义式）：subprocess.Popen 单行 ====="
grep -nE 'subprocess\.Popen\([^)]*shell\s*=\s*True' demo.py || echo "（无命中）"

echo ""
echo "===== 正则2：os.system 行续接形态 ====="
grep -nE '\bsystem\s*\(' demo.py || echo "（无命中 —— 漏报）"

echo ""
echo "===== 正则3（破坏后）：shell=False 被误报 ====="
grep -nE 'subprocess\.Popen\([^)]*shell' demo.py

echo ""
echo "===== semgrep 自定义规则 ====="
semgrep --version
semgrep --config danger.yml demo.py --json 2>/dev/null | python3 -c "import json,sys; d=json.load(sys.stdin); print('Findings:', len(d['results'])); [print(' -', r['path'].split('/')[-1], r['check_id'], 'line', r['start']['line']) for r in d['results']]"
echo "（3 个命中，无误报：shell=False 未被标记）"
