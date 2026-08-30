# 练习7: chmod +x 可执行权限

## 现象
- chmod前: `./demo.sh` 报 Permission denied
- chmod后: `./demo.sh` 正常执行

## 为什么需要执行权限
- Unix系统中文件能否直接作为程序执行由执行权限位(x)控制
- 脚本直接运行需: ①执行权限 ②首行shebang（#!/usr/bin/env bash）
- 无执行权限时可用解释器显式运行: `bash demo.sh`（只需读权限）

## chmod前后对比
| 阶段 | 权限 | 含义 |
|------|------|------|
| chmod前 | -rw-r--r-- | 无人可执行 |
| chmod +x后 | -rwxr-xr-x | 所有人增加执行权限 |

## 常用chmod用法
| 命令 | 作用 |
|------|------|
| chmod +x file | 所有人添加执行权限 |
| chmod u+x file | 仅所有者添加执行权限 |
| chmod 755 file | rwxr-xr-x |
| chmod 644 file | rw-r--r-- |

参考: man chmod
