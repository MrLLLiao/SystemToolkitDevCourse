# 练习12: 搭建隔离环境，安全运行编程智能体的 YOLO/自主模式

## 练习要求
编程智能体大多支持某种"YOLO 模式"（如 Claude Code 的 `--dangerously-skip-permissions`）。
直接在宿主上用不安全；但**在虚拟机/容器等隔离环境里启用自主操作**是可以接受的。
请在本机搭建这样的环境（参考 Claude Code devcontainers / Docker Sandboxes 思路）。

## 思路：容器即隔离边界
`docker-compose.yml` 把一个"agent 沙箱"容器配置成**密不透风的牢房**，然后把 YOLO 模式的智能体关进去跑：
| 沙箱配置 | 意义 | 对应 Claude Code Sandbox 思路 |
|---|---|---|
| `read_only: true` | 根文件系统只读，agent 改不了系统/镜像文件 | 容器 rootfs 只读 |
| `cap_drop: [ALL]` | 丢弃全部 Linux 能力，mount/chown/setuid 全部不可用 | 最小权限容器 |
| `security_opt: no-new-privileges:true` | 禁止通过 setuid 提权 | no_new_privs |
| `pids_limit: 64` | 进程数上限，进程炸弹被内核拒掉 | pids cgroup |
| `mem_limit: 256m` | 内存上限 | memory cgroup |
| `network_mode: none` | 完全断网，无法外联/外泄 | 无网络沙箱 |
| 命名卷 `workdir` | 唯一可写盘区，退出即弃（或挂宿主安全区收集产物） | 独立工作目录 |

Dockerfile 里用**非 root 用户** `agent`（uid 1000）运行，进一步收窄权限。

## 验证（`bash solve.sh` 复现，见 output.txt）
在沙箱内运行 `yolo_demo.sh`，8 项边界逐一实锤：
1. **CapEff = 0000000000000000** → 无任何能力，特权操作从内核层面被禁；
2. **NoNewPrivs = 1** → 无法借 setuid 提权；
3. **根挂载为 overlay ro** → 系统盘只读；
4. **写 /etc 被拒** → 改不了系统文件；
5. **接口只剩 lo、curl 失败** → 断网，数据出不去；
6. **pids.max = 64** → 进程数被限；
7. **memory.max = 268435456 (256MiB)** → 内存被限；
8. **能在 /work/workdir 正常写盘** → 正常开发功能不受影响。
容器退出后 `compose down --volumes` 清理，宿主一个字节都没被动过。

> 注：最初的演示脚本本想"真的尝试 rm -rf /etc、mount 等越界操作"，被本环境的系统安全策略拦截
> （这类高危操作任何模式都不允许，即使发生在容器内）。改成了**只读探测边界**的方式——
> 直接读取 CapEff/NoNewPrivs/挂载/cgroup 证明配置生效，效果等价且 100% 安全。

## 把真实编程智能体跑进沙箱
```bash
# 交互式进入沙箱
docker compose run --rm sandbox bash
# 在沙箱内安装/挂载智能体 CLI，再以 YOLO 模式启动：
#   claude --dangerously-skip-permissions      （Claude Code，需挂载凭据时谨慎）
# 或用 devcontainer 方式：把上述 compose 作为 devcontainer.json 的 runArgs 使用
```
原则：**凭据不进沙箱或只读挂载最小集；产出经命名卷/工作区取回；沙箱可随时 `down --volumes` 重建**。
这样即使 agent 在自主模式下"犯浑"，最坏结果也只是毁掉一个可丢弃的容器。

## 验证
- `docker compose build && docker compose up` 输出见 output.txt；8 项边界全部 PASS；
- 首轮构建曾遇 apt 瞬时报错（exit 100），`compose up` 触发重建即成功（构建可重试）；
- `docker compose down --volumes` 清理干净，宿主无残留。