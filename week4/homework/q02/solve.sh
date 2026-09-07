#!/usr/bin/env bash
# 练习2：生成并查看覆盖率报告
set -uo pipefail
cd /root/gitRepo/MudGame

if [ ! -d build-cov ]; then
  echo "build-cov 不存在，先配置覆盖率构建（需代理拉取依赖）..."
  GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=http.proxy GIT_CONFIG_VALUE_0=http://172.26.224.1:7890 \
    cmake -B build-cov -DCMAKE_BUILD_TYPE=Debug -DCMAKE_CXX_FLAGS="--coverage -O0 -g" > /dev/null 2>&1
fi
cmake --build build-cov -j8 > /dev/null 2>&1
echo "ctest 结果："
ctest --test-dir build-cov 2>&1 | tail -3
echo ""
echo "覆盖率汇总："
./scripts/coverage.sh 2>&1 | tail -8
echo ""
echo "HTML 报告：coverage/index.html（genhtml 输出）"
