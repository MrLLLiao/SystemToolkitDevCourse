# 智能体执行日志（agent 模式，q07）

## 第 1 步：探索（读代码）
- Read wordcount/wordcount.py：发现它是 argparse 命令行工具，
  - 参数：files(nargs="+") + -l/-w/-c(store_true)；
  - count_file() 以字节读取文件，统计行/词/字节；
  - main() 用 flags 三元组决定打印哪些列，多文件时输出 total。
- Read testdata/sample.txt：4 行、18 词、104 字节，含 hello×3。

## 第 2 步：计划
- 新功能属于"独立的附加输出"，最安全做法：
  ① 加 --top 参数（type=int, metavar="N"）；
  ② 新增 collect_words(paths) 纯函数（可单测）；
  ③ 在 main() 末尾 if args.top: 打印高频词；
- 不动 count_file 与 -l/-w/-c 逻辑 → 零回归风险。

## 第 3 步：实现
- 在 wordcount_top.py 中实现（collect_words + Counter.most_common）。

## 第 4 步：验证
- python3 wordcount_top.py testdata/sample.txt          → 4  18  104（与原基线一致）
- python3 wordcount_top.py --top 3 testdata/sample.txt  → hello×3 排第 1
- python3 wordcount_top.py -w testdata/sample.txt       → 只输出词数（-w 行为未变）
- 用 diff 对照基线非 --top 输出 → 无差异。

## 结论
- 智能体模式的主要开销在"探索+计划"，收益是：
  跨文件一致性（collect_words 可复用/可测）、主动验证（真实运行 + 对照基线）。