# 练习1: venv 环境差异 — printenv before/after 对比与 deactivate

## 练习要求
用 `printenv` 把环境存到文件，创建 venv、激活后再次 `printenv` 存到另一文件，用 `diff` 比较 `before.txt` 与 `after.txt`：环境里到底变了什么？为什么 shell 会"优先"使用 venv？运行 `which deactivate` 并推理 deactivate 这个 bash 函数做了什么。

## 实验过程（solve.sh 自动完成）
1. `printenv > before.txt`（22 行）
2. `python3 -m venv .venv` 创建虚拟环境
3. `source .venv/bin/activate` 激活
4. `printenv > after.txt`（25 行）
5. `diff before.txt after.txt`
6. `which deactivate` + `type deactivate` 观察

## diff 结果（差异只有 4 处，见 diff.txt / output.txt）
```
9a10      > VIRTUAL_ENV=/root/gitRepo/SystemToolkitDevCourse/week3/homework/q01/.venv
14a16     > VIRTUAL_ENV_PROMPT=.venv
15a18     > PS1=(.venv)
17c20     < PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:...
          > PATH=/root/gitRepo/SystemToolkitDevCourse/week3/homework/q01/.venv/bin:/usr/local/sbin:...
```

### 环境到底变了什么？
| 变量 | 变化 | 含义 |
|------|------|------|
| `VIRTUAL_ENV` | 新增 | 标记当前激活的 venv 绝对路径，是"当前在哪个环境"的权威标识 |
| `VIRTUAL_ENV_PROMPT` | 新增 | 提示符前缀 `.venv` |
| `PS1` | 新增 | shell 提示符变成 `(.venv) `，让用户肉眼看到自己在 venv 里 |
| `PATH` | 改变 | **在原有 PATH 最前面插入了 `.venv/bin`**，其余路径原样保留 |

注意：diff 里看不到 `_OLD_VIRTUAL_PATH`/`_OLD_VIRTUAL_PS1`，因为 activate 脚本保存它们时**没有 export**，只是普通 shell 变量，`printenv` 只输出导出的环境变量——这正好解释了 deactivate 为什么是 shell 函数而非可执行文件（见下）。

## 为什么 shell "优先"使用 venv？
因为 `PATH` 被前置插入 `.venv/bin`。shell 查找命令时按 PATH 顺序逐个目录搜索，**先命中者胜**：
- 激活前：`which python3` → `/usr/bin/python3`
- 激活后：`which python` → `.../q01/.venv/bin/python`（虽然系统里其实只有 `python3`，venv 会放一个 `python` 软链）

同理 `pip`、`python`、以及 venv 里安装的任何可执行脚本都会先命中 `.venv/bin` 里的版本。这就是"环境隔离"的机制核心：不是改了系统的 Python，而是在 PATH 上"遮蔽"（shadow）了它，让该 shell 会话优先解析到 venv 内程序。

## `which deactivate` 说明了什么？
```
$ which deactivate
(找不到可执行文件 —— 不在 PATH 中)
$ type deactivate
deactivate is a function
```
`deactivate` **不是一个可执行文件，而是一个 bash 函数**。原因：deactivate 必须修改当前 shell 自身的环境变量（PATH、PS1、VIRTUAL_ENV），而**子进程无法修改父 shell 的环境**——如果它是独立可执行文件，运行它只会改自己进程里的副本，当前 shell 完全不受影响。只有 `source` 进来的 shell 函数才能就地改当前 shell。这也解释了 `activate` 为什么必须用 `source`（`.`）而不是直接执行。

## deactivate 函数做了什么（type deactivate 输出 + 推理）
1. 若 `_OLD_VIRTUAL_PATH` 有值 → 把 `PATH` **还原**为激活前保存的旧 PATH，并 unset 它；
2. 若 `_OLD_VIRTUAL_PYTHONHOME` 有值 → 还原 `PYTHONHOME`（本实验未设置，故不触发）；
3. `hash -r` 清空 shell 的命令哈希缓存（否则 shell 可能仍记住旧路径）；
4. 还原 `PS1`（`_OLD_VIRTUAL_PS1`）；
5. `unset VIRTUAL_ENV` 和 `VIRTUAL_ENV_PROMPT`，撤销"在 venv 里"的标记；
6. 若调用参数不是 `nondestructive`，还 `unset -f deactivate` 把自己删掉。

本质：activate 是"保存旧值 + 覆盖新值"的前向操作，deactivate 是"用保存的旧值恢复 + 清理标记"的逆向操作，两者成对出现、共用 `_OLD_VIRTUAL_*` 这组变量。

## 验证
- 实验后 `deactivate`，`which python3` 回到 `/usr/bin/python3`，`VIRTUAL_ENV` 变回未设置，环境恢复。
- `output.txt` 保存了完整实验输出，可重跑 `bash solve.sh` 复现。

## 总结
- venv 隔离的核心是 **PATH 前置遮蔽 + VIRTUAL_ENV 标记 + PS1 提示**，并未修改系统 Python。
- `activate`/`deactivate` 必须走 `source` 的 shell 函数，因为只有函数能改当前 shell 环境。