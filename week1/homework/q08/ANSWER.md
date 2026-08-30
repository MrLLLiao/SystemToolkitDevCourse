# 练习8: set -x 调试选项

## set -x 的作用
- `set -x` 开启 xtrace 模式：Shell 在执行每条命令前，先将展开后的命令打印到 stder
- 输出以 `+` 开头，显示变量展开后的实际值
- `set +x` 关闭调试模式

## 输出示例解读
```
+ echo 开始计算
开始计算
+ a=10
+ b=20
+ sum=30
+ echo 'a + b = 30'
a + b = 30
+ '[' 30 -gt 15 ']'
+ echo 结果大于15
结果大于15
+ set +x
调试结束
```
- `+` 开头的行是 xtrace 输出（到stderr）
- 其他行是命令的正常输出（到stdout）
- 可以看到变量 `$sum` 被展开为实际值 `30`

## 其他有用的 set 选项
| 选项 | 作用 |
|------|------|
| `set -e` | 命令失败时立即退出脚本 |
| `set -u` | 使用未定义变量时报错 |
| `set -o pipefail` | 管道中任一命令失败则整个管道失败 |
| `set -x` | 打印执行的命令（调试用） |

常组合使用: `set -euo pipefail`

参考: https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
