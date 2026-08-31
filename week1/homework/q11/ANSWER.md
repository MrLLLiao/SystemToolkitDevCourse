# 练习11: Git 数据模型与核心对象

## Git 数据模型核心概念

Git 本质上是一个**内容寻址的文件系统**。仓库中的所有对象都通过其内容的 SHA-1 哈希来寻址和存储。

## 三种核心对象

| 对象 | 作用 | 内容 |
|------|------|------|
| **blob** | 存储文件内容 | 文件的字节流（不含文件名） |
| **tree** | 存储目录结构 | 一组 (文件名, 类型, hash) 条目，指向 blob 或子 tree |
| **commit** | 存储快照 | tree 引用、父 commit 引用、作者、提交者、时间戳、提交消息 |

## 对象关系

```
commit (含元数据+指向tree)
  `-- tree (目录快照)
       |-- greeting.txt -> blob(hello git)
       |-- notes.txt    -> blob(line1)
       `-- subdir/      -> tree(子目录)
```

## 内容寻址

- 每个对象以 SHA-1(content + 类型头) 作为 hash
- 相同内容的对象有相同 hash（去重）
- 文件内容变了 -> blob hash 变 -> tree 变 -> commit 变（形成链）

## 关键命令

| 命令 | 作用 |
|------|------|
| `git cat-file -t <hash>` | 查看对象类型 |
| `git cat-file -p <hash>` | 查看对象内容 |
| `git rev-parse HEAD` | 查看 HEAD 的完整 hash |
| `git log --oneline` | 查看提交历史 |

## 练习内容
- 创建演示仓库，用 git cat-file 逐步拆解 commit -> tree -> blob 对象
- 验证"内容寻址"：修改文件后 commit hash 变化
- 通过 git cat-file -p HEAD 观察 commit 对象结构

参考: https://git-scm.com/book/en/v2, https://missing-semester-cn.github.io/2026/version-control/
