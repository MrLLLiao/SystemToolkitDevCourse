# 练习7：Makefile（git ls-files 驱动 + .PHONY）

## 练习内容
按讲义用 git ls-files 驱动文件清单，Makefile 声明 .PHONY 伪目标，避免与同名真实文件冲突。

## 实现
根目录新增 Makefile：
- `SOURCES := $(shell git ls-files 'src/*.cpp' 'src/**/*.cpp')` —— 共 30 个源文件
- `.PHONY: all build test coverage list clean` 伪目标声明
- 目标：build（cmake）、test（ctest）、coverage（lcov 脚本）、list（列出源文件）、clean（删 build/、build-cov/、coverage/）

## 坑
仓库 .gitignore 原本把 `Makefile` 当作 CLion 产物忽略，需加 `!Makefile` 例外才能提交。

## 验证结果
make list 列出 30 个源文件；make build + make test（21/21）通过；make clean 删除三个构建目录。

## 对应提交
- 715553e feat(build): 新增Makefile封装，git ls-files驱动清单与PHONY伪目标
