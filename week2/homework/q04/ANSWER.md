# 练习4: marco 与 polo 环境变量函数

## 练习要求
写两个 bash 函数 `marco` 和 `polo`：
- 每次执行 `marco` 时，以某种方式保存当前工作目录；
- 之后无论切到哪个目录，只要执行 `polo`，就 `cd` 回执行 `marco` 时所在的目录。

## 实现（marco.sh）

```bash
marco() {
    export MARCO_DIR="$(pwd)"      # 把当前目录保存进环境变量
    echo "marco: 已保存目录 $MARCO_DIR"
}
polo() {
    if [ -z "${MARCO_DIR:-}" ]; then
        echo "polo: 还没有执行过 marco" >&2
        return 1
    fi
    cd "$MARCO_DIR"                 # 回到保存的目录
    echo "polo: 已回到 $PWD"
}
```

## 关键点
- 通过 `export MARCO_DIR="$(pwd)"` 把目录保存进**环境变量**，函数和子 shell 都能访问。
- 加载方式：`source marco.sh`（或 `. marco.sh`）在当前 shell 中定义函数，之后即可交互式使用：
  ```bash
  source marco.sh
  cd /some/dir && marco
  cd /elsewhere
  polo            # 回到 /some/dir
  ```
- 若想跨 shell 会话持久保存，可把目录写入临时文件（例如 `~/.marco_dir`），polo 时读取。本练习采用环境变量方案，简洁且符合"当前会话内随时 polo"的语义。

## 演示结果
solve.sh 中依次：创建目录 A、B → 进入 A 执行 `marco` → 切到 B → 执行 `polo` → 验证 `$PWD` 已回到 A，验证通过。
