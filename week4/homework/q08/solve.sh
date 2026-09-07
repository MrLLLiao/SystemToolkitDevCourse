#!/usr/bin/env bash
# 练习8：Rust 版本语义实测（在 MudGame/rust-version-demo 上验证）
set -uo pipefail
cd /root/gitRepo/MudGame/rust-version-demo

echo "===== 场景代码（掷骰子，rand 0.8 API） ====="
cat src/main.rs

echo ""
echo "===== 骰子运行 4 次 ====="
for i in 1 2 3 4; do
  echo -n "第 ${i} 次: "
  CARGO_HTTP_PROXY=http://172.26.224.1:7890 cargo run --quiet 2>/dev/null || echo "编译/运行失败"
done

echo ""
echo "===== 版本约束解析实测 ====="
run_case() {
  local req="$1"
  sed -i "s/rand = \".*\"/rand = \"$req\"/" Cargo.toml
  local out
  out=$(CARGO_HTTP_PROXY=http://172.26.224.1:7890 cargo update --dry-run -p rand 2>&1 || true)
  if echo "$out" | grep -q 'failed to select'; then
    echo "  $req  -> 解析失败（no matching version）"
    return
  fi
  local v
  v=$(echo "$out" | grep -oE '(Downgrading|Updating) rand v[0-9.]+ -> v[0-9.]+' | grep -oE 'v[0-9.]+$' | head -1 | tr -d 'v')
  if [ -n "$v" ]; then
    echo "  $req  -> $v"
  else
    # 约束已满足（Locking 0 packages）：读当前 lock 解析版本
    local cur
    cur=$(cargo metadata --format-version 1 2>/dev/null | python3 -c "import json,sys; print([p['version'] for p in json.load(sys.stdin)['packages'] if p['name']=='rand'][0])")
    echo "  $req  -> $cur"
  fi
}
run_case "^0.8"
run_case "^0.8.3"
run_case "~0.8.4"
run_case "0.8.*"
run_case ">=0.8, <0.9"
run_case "=0.8.4"
run_case ">=1.0, <1.5"
run_case ">=0.8.5"

# 还原为演示项目的原始约束
git restore Cargo.toml
echo ""
echo "（已还原 Cargo.toml 约束为 ^0.8）"
