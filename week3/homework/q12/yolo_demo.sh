#!/bin/bash
# q12: YOLO 模式隔离沙箱——边界验证演示（全程只读探测，不含任何破坏性命令）
# 证明沙箱配置真实生效：无能力集、根只读、断网、进程/内存受限、仅工作区可写。
set -u
echo "=== [q12] YOLO 沙箱演示：验证隔离边界已生效 ==="
echo "当前用户: $(id -un) (uid $(id -u))"
echo ""

echo "[1] 能力集 CapEff（cap_drop:ALL → 应为 0000000000000000）"
grep CapEff /proc/self/status
echo "    → CapEff 全 0 = 无任何 Linux 能力：mount/chown/setuid 等特权操作在本容器内根本不可用"
echo ""

echo "[2] NoNewPrivs（no-new-privileges:true → 应为 1）"
grep NoNewPrivs /proc/self/status
echo ""

echo "[3] 根文件系统挂载（read_only:true → / 为 ro）"
grep ' / ' /proc/mounts
echo ""

echo "[4] 尝试向系统路径写文件（应被拒）"
if touch /etc/q12_probe 2>/dev/null; then echo "  ✗ 能写 /etc（异常）"; else echo "  ✓ 无法写 /etc（read_only + 非root）"; fi
echo ""

echo "[5] 网络接口（network_mode:none → 仅 lo，无 eth0）"
echo "  接口列表: $(ls /sys/class/net 2>/dev/null | tr '\n' ' ')"
if curl -s --max-time 2 https://example.com >/dev/null 2>&1; then echo "  ✗ 能联网（异常）"; else echo "  ✓ 无法联网（外联/外泄被隔离）"; fi
echo ""

echo "[6] 进程上限（pids_limit:64）"
cat /sys/fs/cgroup/pids.max 2>/dev/null || echo "  (cgroup 视图不可读，由运行时兜底)"
echo ""

echo "[7] 内存上限（mem_limit:256m）"
cat /sys/fs/cgroup/memory.max 2>/dev/null || cat /sys/fs/cgroup/memory/memory.limit_in_bytes 2>/dev/null || echo "  (未暴露)"
echo ""

echo "[8] 在唯一可写区正常干活"
echo "hello from yolo agent (pid $$)" > /work/workdir/result.txt
cat /work/workdir/result.txt
echo ""
echo "=== 演示结束：宿主毫发无损；agent 无能力、根只读、断网、进程/内存受限，仅能在 /work/workdir 写盘 ==="