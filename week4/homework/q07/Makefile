# 元编程练习：用 git ls-files 驱动源文件清单（而非 find），
# .PHONY 声明伪目标，避免与同名真实文件冲突。
SOURCES := $(shell git ls-files 'src/*.cpp' 'src/**/*.cpp')
TESTS   := $(shell git ls-files 'tests/**/*.cpp')

.PHONY: all build test coverage list clean

all: build

build:
	cmake -S . -B build >/dev/null && cmake --build build -j$(nproc)

test: build
	ctest --test-dir build --output-on-failure

coverage:
	bash scripts/coverage.sh

list:
	@echo "git ls-files 列出的源文件（$(words $(SOURCES)) 个）："
	@printf '  %s\n' $(SOURCES)

clean:
	rm -rf build build-cov coverage
	@echo "clean 完成：已删除 build/ build-cov/ coverage/（伪目标由 .PHONY 声明）"
