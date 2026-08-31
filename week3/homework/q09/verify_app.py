"""q09: 对氛围编程产出的应用做结构与关键功能点自检。"""
import pathlib
import re

html = pathlib.Path(__file__).with_name("index.html").read_text(encoding="utf-8")

# 结构：恰一个 script 块
assert html.count("<script>") == 1 and html.count("</script>") == 1, "脚本块数量异常"

# 关键功能点
checks = {
    "倒计时默认 25:00": "25 * 60" in html or "25:00" in html,
    "开始/暂停/重置": all(x in html for x in ["startBtn", "resetBtn", "pause()"]),
    "时长切换 25/45/60": all(x in html for x in ['"25"', '"45"', '"60"']),
    "提示音 Web Audio": "AudioContext" in html,
    "待办 localStorage 持久化": "localStorage" in html and "todoText" in html,
    "无外部依赖(无 http/link/src)": not any(
        x in html for x in ["http://", "https://", "<script src", "<link "]
    ),
}
for k, v in checks.items():
    print(("  [OK] " if v else "  [!!] ") + k)
assert all(checks.values()), "存在未通过项"
print("PASS: 全部关键功能点存在，且无外部依赖")