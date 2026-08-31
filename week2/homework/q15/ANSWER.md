# 练习15: 用 strace 追踪系统调用

## 练习要求
用 `strace` 追踪 `ls -l` 这类命令的系统调用，看看它都调用了哪些系统调用；再追踪一个更复杂的程序，观察它打开了哪些文件。

## 1) 系统调用汇总：strace -c
`strace -c ls -l` 统计每次系统调用的次数与耗时。`ls` 一次运行主要涉及：

| 系统调用 | 作用 |
|----------|------|
| `execve` | 启动 ls 进程（加载可执行文件） |
| `brk` / `mmap` | 堆/内存映射（加载动态库、分配内存） |
| `openat` | 打开文件（读目录、读 /etc/hostname 等） |
| `getdents64` | 读取目录项（列出目录内容） |
| `read` / `write` | 读写数据 / 把结果写到终端 |
| `close` / `fstat` | 关闭文件描述符 / 获取文件元信息 |
| `access` | 检查文件访问权限 |

## 2) 关注文件类系统调用
```bash
strace -e trace=openat,open,access ls -l /etc/hostname
```
可见 ls 通过 `openat(AT_FDCWD, "/etc/hostname", O_RDONLY)` 打开目标文件，`access` 检查路径可访问性。

## 3) 追踪 write
```bash
strace -e trace=write echo hello
```
可见 `write(1, "hello\n", 6)`：fd 1 是标准输出，一次 write 把整行写到终端。

## 4) 追踪复杂程序（python3）
```bash
strace -e trace=openat python3 -c "print('hi')"
```
python3 启动时会 `openat` 打开一堆文件：解释器可执行文件、`libpython3.x.so`、`libc.so.6` 等动态库、`encodings/` 编码模块等——这正是"程序启动背后有大量文件 I/O"的直观证据。

## 实测结果
见 output.txt：`-c` 汇总表、`ls` 的 openat 调用、`echo` 的 write 调用、python3 启动时打开的动态库/模块文件路径。

## 补充
- `strace -p <pid>` 可附加到运行中的进程追踪；`-f` 跟踪子进程。
- WSL 环境下 strace 基于 ptrace，工作正常；这就是调试"程序到底打开了什么/做了哪些系统调用"的标准工具。
