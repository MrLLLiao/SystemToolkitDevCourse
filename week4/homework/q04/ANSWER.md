# 练习4：用正则找危险 shell 调用，semgrep 兜底

## 练习内容
按讲义在代码库中搜索 `subprocess.Popen(..., shell=True)` 一类危险调用，体验正则在真实代码前的失效方式，再用 semgrep 自定义规则兜底。

## 正则的三种失效（见 output.txt 实测）
1. **漏报-多行参数**：讲义式正则 `subprocess\.Popen\([^)]*shell\s*=\s*True` 只能命中单行调用，多行书写的 Popen 被漏掉
2. **漏报-行续接**：`os.system \` 换行 `(` 形态绕过了 `\bsystem\s*\(`
3. **误报-破坏正则**：去掉 `=\s*True` 后，shell=False 的安全调用被误报
另外 grep 的 POSIX ERE 不支持懒惰量词与非捕获组，复杂匹配需 perl PCRE。

## semgrep 兜底
自定义规则（AST 级匹配）同时命中单行 Popen、多行 Popen、多行 os.system 三种形态，且无误报。结论：安全相关检查交给语法树级工具，正则适合定位与快速过滤。

## 生产代码结论
MudGame 生产代码无 system/popen 调用（仅在 build/_deps 第三方 googletest 中出现）。

## 对应提交
无（技术演示，未产生仓库改动）
