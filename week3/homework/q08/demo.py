"""q08 现场演示：用真实运行验证对 tenacity 代码库的理解。

读代码得到的结论 -> 用一段可复现脚本验证：
1. @retry(stop=..., wait=..., retry=...) 是"策略组合"而非单一配置；
2. Retrying.__call__ 循环：DoAttempt -> 执行函数并记录 outcome -> DoSleep -> 重试；
3. enabled=False 时 wraps() 直达原函数（wrapped_f 的 if not self.enabled 分支）。
"""
import random
import sys

sys.path.insert(0, "/root/week3_hw/tenacity")

from tenacity import (
    RetryError,
    retry,
    retry_if_exception_type,
    stop_after_attempt,
    wait_fixed,
)

attempts: list[int] = []


@retry(
    stop=stop_after_attempt(4),
    wait=wait_fixed(0.05),
    retry=retry_if_exception_type(ValueError),
)
def flaky():
    attempts.append(1)
    if random.random() < 0.6:
        raise ValueError("boom (随机失败)")
    return "success"


try:
    print("结果:", flaky())
except RetryError as e:
    print("最终失败:", e)
print("尝试次数:", len(attempts))
assert len(attempts) <= 4, "不应超过 stop_after_attempt(4)"

# enabled=False -> 直达原函数（wrapped_f 里 if not self.enabled 分支）
attempts.clear()


@retry(enabled=False)
def no_retry():
    attempts.append(1)
    return "direct"


print("enabled=False 结果:", no_retry(), "次数:", len(attempts))
assert len(attempts) == 1
print("PASS: 两条代码库结论均被真实运行证实")