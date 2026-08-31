# tenacity 代码库分析（SCOPE → ROUTE → EFFECT → BREAK → SHIP）

## 1. 身份 / 范围 / 证据等级
- revision: `26f719d`（2026-08-06，"Respect enabled=False on the direct-call path"）
- 范围：已读 `tenacity/__init__.py`（870 行，含 retry()/BaseRetrying/Retrying/wraps）、
  `tenacity/stop.py`、`tenacity/wait.py`（类清单）、`tenacity/retry.py`（类清单）、
  `tenacity/asyncio/__init__.py`（类清单）、tests/ 目录结构。
  未精读：`_utils.py`、`nap.py`、`tornadoweb.py`、`after/before/before_sleep` 的具体策略体。

证据矩阵（每个 current-fact 的级别）：
| 事实 | 定位 | 级别 |
|---|---|---|
| retry() 支持 @retry 与 @retry() 两种写法 | __init__.py:771-779 | confirmed |
| 根据是否协程选择 Async/Tornado/Sync 控制器 | __init__.py:781-795 | confirmed |
| enabled=False 时 wrapped_f 直达原函数 | __init__.py:368-371 | confirmed |
| Retrying.__call__ 循环用 DoAttempt/DoSleep 哨兵 | __init__.py:534-558 | confirmed |
| 首次迭代挂 before；后续挂 retry 谓词 | __init__.py:_begin_iter 445-457 | confirmed |
| 不重试则 `rs.outcome.result()` 直接返回 | __init__.py:_post_retry_check_actions 460 | confirmed |
| stop 命中且 reraise=True 会重抛原异常 | __init__.py:_post_stop_check_actions 475-482 | confirmed |
| statistics 按线程隔离（threading.local） | __init__.py:336-348 | confirmed |
| stop_after_attempt 比较 attempt_number>=max | stop.py:89-96 | confirmed |
| 重试语义"实现了"不等同于"生产激活" | 需由调用方 @retry 开启 | conditional |

## 2. 直接答案（入口/调用链/数据流/模块责任）
- **入口**：`@retry(...)` 装饰器（__init__.py:736）。支持 `@retry` 与 `@retry()`；
  返回 `wraps(f)` 的包装函数，包装函数带 `.retry` / `.retry_with` / `.statistics` 属性。
- **调用链**：`wrapped_f(*a,**kw)` → (`enabled` 关→直达 f) → `copy=self.copy()` →
  `copy(f,*a,**kw)`（Retrying.__call__）→ while 循环 `iter(retry_state)` →
  `DoAttempt`: 执行 fn、`set_exception/set_result` 记录 outcome →
  `DoSleep`: `prepare_for_next_attempt()` + `sleep(do)` → 循环；返回值为 `do`（结果或异常）。
- **数据流**：`RetryCallState` 一个对象贯穿每次尝试：outcome（成功值/异常）、attempt_number、
  idle_for、seconds_since_start、upcoming_sleep；`statistics` 放 `threading.local`。
- **模块责任**：
  - `__init__.py`：控制器 + 状态机 + 工厂 + 哨兵（核心）；
  - `retry.py`：决定"要不要重试"的谓词（可 & | 组合）；
  - `stop.py`：决定"何时停"；`wait.py`：决定"睡多久"；
  - `before/after/before_sleep`：在尝试前/后/睡前挂钩子；
  - `asyncio/`、`tornadoweb.py`：异步变体，复用同一状态机（不同 sleep）。

## 3. 最短主链（一次"失败→重试→成功"）
```
@retry(stop=stop_after_attempt(4), wait=wait_fixed(0.05), retry=retry_if_exception_type(ValueError))
  → wraps(f) → Retrying.__call__
  → begin() (statistics 初始化, attempt=1)
  → iter: before_nothing → DoAttempt
  → fn() 抛 ValueError → set_exception
  → iter: retry 谓词返回 True → after → wait(0.05) → stop(未到4次, False) → DoSleep(0.05)
  → prepare_for_next_attempt → sleep(0.05) → attempt=2 → iter → DoAttempt → fn() 成功
  → iter: retry 谓词对成功 outcome 返回 False → _post_retry_check_actions → outcome.result() 返回
```

## 4. 责任闭合卡（重试/延迟效果）
| 对象/范围 | 触发者 | 当前装配/开关 | 实际执行者 | 成功副作用与观察点 | 失败是否返回且被检查 | 重试来源 | 不能覆盖的对象 | status |
|---|---|---|---|---|---|---|---|---|
| Retrying 重试循环 | 调用方 @retry 装饰 | `enabled`(默认 True)、`stop/wait/retry/before/after` 策略对象 | `Retrying.__call__` + `iter()` 动作流水线 | 重试至成功或 stop 命中；statistics 累计 | stop 命中→抛 RetryError（或 retry_error_callback）；永不静默吞异常 | `retry` 谓词 + `TryAgain` 显式重试 | 装饰器之外的裸调用不重试 | confirmed |
| wait 延迟 | 每次准备重试前 | `wait` 策略 | `self.wait(retry_state)` → DoSleep → `sleep()` | 实际睡眠 = wait 策略返回值 | 无（sleep 阻塞） | — | wait=None/0 时 sleep=0 | confirmed |
| enabled=False | wrapped_f 首次调用 | `enabled` 开关 | `wrapped_f` 直接 `f(*args,**kw)` | 一次调用、无 statistics 副作用 | 原样传播 f 的异常 | 无 | 若通过 `retry_with(enabled=True)` 覆盖则仍重试 | confirmed |

## 5. 反例/边界（BREAK）
- `enabled=False`：不重试、不做 begin()（__init__.py:368 与 533 两个判断点）。
- `retry` 谓词对"成功结果"返回 False → 直接 `outcome.result()`，不 sleep。
- `TryAgain` 显式抛出 → `is_explicit_retry=True`，绕过 retry 谓词直接重试（_begin_iter:445-451）。
- `stop_after_delay` 语义：可能超时一点（注释明说 max_delay 会被 exceed），严格用 stop_before_delay。
- 多线程共享同一 Retrying 对象：statistics/iter_state 各自线程局部，互不污染。

## 6. 会改变答案的未知与最小验证
- 未读 `_utils.py` 的 `is_coroutine_callable`/`to_seconds`——影响异步分支与时延换算；
  最小验证：读 `_utils.py` 对应函数（本次未做，标注为 inferred 边界）。
- 已用 `demo.py` 实际运行验证"策略组合 + enabled=False"两条核心结论（见 output.txt）。

## 一句话总结
`tenacity` = **策略对象组合 + 一个状态机控制器**：`retry()` 把 stop/wait/retry/before/after 组合进
`Retrying` 控制器，控制器跑"动作流水线"并用 `DoAttempt/DoSleep` 哨兵把"执行函数/休眠"交回调用方，
因此同步、asyncio、tornado 三种执行后端共用同一套重试逻辑。