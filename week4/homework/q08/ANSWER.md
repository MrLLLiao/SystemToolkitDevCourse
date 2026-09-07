# 练习8：Rust 版本语义

## 练习内容
用 cargo 实际验证 caret、tilde、通配、范围、精确、多约束六种版本要求的解析结果，并构建一个真实场景（掷骰子）。

## 场景
rust-version-demo 依赖 rand 0.8（`rand::thread_rng().gen_range(1..=6)` 掷骰子；rand 0.9 改名为 random_range，API 不兼容）。逐个改写 Cargo.toml 的版本要求，用 `cargo update --dry-run` + `cargo metadata` 观察解析结果。

## 实测结果（cargo 1.93.1）
| 版本要求 | 解析结果 | 说明 |
|---|---|---|
| ^0.8 | 0.8.8 | caret：≥0.8.0 且 <0.9.0（0.x 锁次版本） |
| ^0.8.3 | 0.8.8 | caret：≥0.8.3 且 <0.9.0 |
| ~0.8.4 | 0.8.8 | tilde：≥0.8.4 且 <0.9.0 |
| 0.8.* | 0.8.8 | 通配：仅 0.8.x |
| >=0.8, <0.9 | 0.8.8 | 范围：多约束交集 |
| =0.8.4 | 0.8.4 | 精确匹配 |
| >=1.0, <1.5 | 解析失败 | "no matching version" |
| >=0.8.5 | 0.10.2 | 无上限：直接选最新 |

## 对应提交
- 34f8759 feat(rust): 新增Rust版本语义演示项目
- 968fb03 feat(rust): 提交Cargo.lock保证依赖可复现构建
