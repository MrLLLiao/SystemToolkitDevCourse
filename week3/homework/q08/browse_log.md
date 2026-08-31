# 智能体浏览陌生代码库的过程记录（q08）

目标：用 AI 编程智能体（即"我"）浏览一个从没见过的代码库，形成可核验的心智模型。
选材：`jd/tenacity`（Python 通用重试库）——小（包内 2445 行 Python）、单目标（重试）、
与本学期课程（shell 工具/健壮性/自动化）强相关。浅克隆 commit `26f719d`（2026-08-06）。

## 浏览顺序与关键动作
1. **仓库轮廓**：`git ls-files | wc -l`=92；顶层=LICENSE/README.rst/doc/pyproject.toml/tests/tenacity；
   包内模块=`__init__.py _utils.py after.py asyncio/ before.py before_sleep.py nap.py
   py.typed retry.py stop.py tornadoweb.py wait.py`。
2. **公开 API**：读 `__init__.py` 顶部 import 与 `__all__`——把 after/before/before_sleep/
   retry/stop/wait/asyncio 各策略 re-export 到包根，方便 `from tenacity import *`。
3. **类图**：`grep -E "^(class|def) "` 枚举全部类：
   - `__init__.py`：`IterState`、`TryAgain`、`DoAttempt`/`DoSleep`/`BaseAction`/`RetryAction`
     （状态机哨兵）、`RetryError`、`AttemptManager`、`BaseRetrying`(ABC)、`Retrying`、
     `Future`、`RetryCallState`、`retry()` 工厂；
   - `retry.py`：`retry_base` + 具体谓词（retry_if_exception_type / retry_if_result …，支持 & | 组合）；
   - `stop.py`：`stop_base` + `stop_after_attempt`/`stop_after_delay`/`stop_before_delay`/`stop_any`…；
   - `wait.py`：`wait_base` + `wait_fixed`/`wait_exponential`/`wait_random_exponential_jitter`…；
   - `asyncio/__init__.py`：`AsyncRetrying(BaseRetrying)`。
4. **入口与调用链**：读 `retry()`（__init__.py:736）→ 返回 `wrap()`：
   - 按 `f` 是否协程函数 / `sleep` 是否协程 → 选 `AsyncRetrying` / `TornadoRetrying` / `Retrying`；
   - `r.wraps(f)`（__init__.py:~354）生成 `wrapped_f`：`enabled=False` 直达 `f`；
     否则 `self.copy()`（避免跨调用污染线程局部状态）+ 清空 statistics 再 `copy(f,...)`。
5. **核心状态机**：读 `Retrying.__call__`（:531）与 `BaseRetrying.iter/_begin_iter/
   _post_retry_check_actions/_post_stop_check_actions`（:~423-528）：
   - `iter()` 返回哨兵 `DoAttempt`（让调用者执行 fn 并记录 outcome）或 `DoSleep`（睡完继续）或 break；
   - 动作流水线决定下一步：首次=before→DoAttempt；之后=retry 谓词→(不重试则取结果返回)→after→wait→stop→
     （stop 命中则抛 RetryError / 回调）否则 DoSleep 并 attempt_number+=1。
6. **数据流**：`RetryCallState`（:588）承载 fn/args/kwargs/outcome/attempt_number/
   idle_for/seconds_since_start/upcoming_sleep 等；`statistics` 用 `threading.local()` 隔离线程。
7. **测试**：`tests/test_tenacity.py`（核心）、test_asyncio/test_tornado/test_utils/test_after/
   test_issue_478——与被测模块一一对应，是理解行为的"可执行文档"。
8. **验证（动手运行）**：写 `demo.py` 用真实重试证明两条结论：
   a) 策略可组合：stop=stop_after_attempt(4)+wait=wait_fixed(0.05)+retry=retry_if_exception_type
      → 间歇失败函数最多 4 次尝试，成功返回；
   b) `enabled=False` → 直达原函数（尝试 1 次）。
   运行结果：`结果: success / 尝试次数: 2 / enabled=False 结果: direct 次数: 1`，断言全过。

## 一句话总结
tenacity 是"策略对象 + 一个状态机控制器"：`retry()` 把 stop/wait/retry/before/after
等策略组合进 `Retrying` 控制器，控制器以生成器/while 循环跑动作流水线，
`DoAttempt/DoSleep` 哨兵把"执行函数"与"休眠"两件事交回调用方，从而同步/异步统一复用一套逻辑。