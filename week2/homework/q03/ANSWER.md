# 练习3: 进程替换与 printenv/export 的差异

## 练习要求
用进程替换 `<(command)` 配合 `diff`，比较 `printenv` 与 `export` 的输出，并解释为什么它们不一样。

## 进程替换 <(command)
`<(command)` 会把命令的输出包装成一个**伪文件**（`/dev/fd/N`），从而可以把它当作文件参数传给其他程序：

```bash
diff <(printenv | sort) <(export | sort)
```

`<(printenv | sort)` 展开成一个类似 `/dev/fd/63` 的路径，diff 像读文件一样读取两个命令的输出做逐行比较。

## printenv 与 export 为什么不一致

| 命令 | 类型 | 输出格式 | 显示范围 |
|------|------|----------|----------|
| `printenv` | 外部程序（/usr/bin/printenv） | 原始 `NAME=value`，无引号 | 当前**进程环境**里的变量 |
| `export` | bash 内建命令 | `declare -x NAME="value"`（bash 5.x），带前缀和引号 | 具有**导出属性**（export attribute）的变量 |

导致 diff 有输出的两个主要原因：

1. **格式不同**：`printenv` 直接输出 `PATH=/usr/bin:...`；而 bash 的 `export`（无参数）输出的是 `declare -x PATH="/usr/bin:..."`，每行都带 `declare -x` 前缀和双引号。所以即使变量完全一样，两边的行文本也不同，diff 必然报差异。
2. **语义略有差别**：`export` 只列出带导出标记的变量；`printenv` 列出的是子进程实际收到的环境。某些只存在于 shell 中且未被标记为导出的变量、以及个别内建环境条目，二者不一定完全重合。

## 实测结论
运行 `diff <(printenv | sort) <(export | sort)` 后，几乎每一行都被 diff 标记为差异（因为一边是 `NAME=value`、一边是 `declare -x NAME="value"`）。若只看"变量名集合"的差异，可分别抽取键名比较，例如：

```bash
comm -3 <(printenv | cut -d= -f1 | sort) <(export | cut -d' ' -f3 | cut -d= -f1 | sort)
```

## 参考
- bash man page：`Process Substitution`（`<(...)` 展开为 /dev/fd/N）
- `help export`：export 无参数时以 `declare -x` 形式打印导出变量
