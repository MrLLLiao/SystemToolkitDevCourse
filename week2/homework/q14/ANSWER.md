# 练习14: 用 AddressSanitizer 调试内存错误

## 练习要求
把 `uaf.c` 保存并编译运行。先用普通方式 `gcc uaf.c -o uaf && ./uaf`（可能看起来正常），再用 ASan `gcc -fsanitize=address -g uaf.c -o uaf && ./uaf` 读取报告，找出 bug 并修复。

## 发现的 bug：use-after-free（释放后使用）
```c
free(greeting);
greeting[0] = 'J';    // 内存已 free, 这里仍读写 -> 未定义行为
printf("%s\n", greeting);
```

- 普通编译运行**可能"看起来正常"**：因为 free 后堆内存内容往往还在，直接读写不一定立刻崩溃，但这属于未定义行为，随时可能出错。
- ASan 在每次 malloc/free 周围插入检查（redzone），能**精确报告**：

```
ERROR: AddressSanitizer: heap-use-after-free
WRITE of size 1 at 0x...
#0 main uaf.c:12          <- 写 greeting[0] 的位置
freed by ... #1 free
allocated by ... #1 malloc
```

## 修复
把对 `greeting` 的读写移到 `free` 之前，`free` 之后不再访问：

```c
greeting[0] = 'J';
printf("%s\n", greeting);
free(greeting);
```

修复后用 `-fsanitize=address` 重新编译运行：正常输出，无 ASan 报错，退出码 0。

## 收获
- ASan（AddressSanitizer）能检测 use-after-free、堆越界、栈越界、泄漏等，是 C/C++ 内存调试的利器。
- 编译选项：`-fsanitize=address -g`（-g 保留符号便于报告显示源码行号）。
- 详见 output.txt 中完整的 ASan 报告（含 WRITE of size 1、freed by、allocated by 的调用栈）。
