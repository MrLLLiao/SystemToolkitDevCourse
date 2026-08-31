# 练习5: 返回码——运行直到失败

## 练习要求
假设有一个很少失败的命令（`flaky.sh`，只有 `RANDOM % 100 == 42` 时才失败）。写一个 bash 脚本不断运行它直到失败为止，把标准输出和标准错误分别保存到文件里，最后打印结果，并报告运行了多少次才失败。

## 核心机制
- `flaky.sh` 每次退出码非 0（`exit 1`）代表失败；成功时退出码为 0。
- 驱动脚本用 `while true` 循环，每次运行后检查 `$?`（上一条命令的退出码）：
  - `$? == 0` → 继续下一轮；
  - `$? != 0` → 记录失败并跳出循环。
- 输出分流：`>> stdout.log 2>> stderr.log` 把标准输出和标准错误**分别追加**到两个文件。

## 关键脚本片段

```bash
while true; do
  count=$((count + 1))
  bash flaky.sh >> stdout.log 2>> stderr.log
  status=$?
  if [ $status -ne 0 ]; then
    break
  fi
done
echo "共运行 $count 次, 第 $count 次失败"
```

## 实测结果
- 因为 `RANDOM % 100 == 42` 的概率约为 1/100，所以通常在几十到一百多次后失败（本次演示具体次数见 output.txt）。
- `stdout.log` 里包含若干行 `Everything went according to plan` 和最后一行 `Something went wrong`。
- `stderr.log` 里只有最后一行 `The error was using magic numbers`（失败那次写入的标准错误）。

## 补充
- `$?` 只能拿到**上一条命令**的退出码；需要先把它保存到变量再继续处理（否则下一次命令会覆盖它）。
- 用 `>>` 追加而不是 `>` 覆盖，才能保留历次运行日志；`2>>` 单独处理 stderr。
