# 练习10：GitHub Pages 与 shellcheck

## 练习内容
给仓库配置 GitHub Pages 部署工作流，并在 CI 中加入 shellcheck 步骤检查 shell 脚本。

## 实现
- `.github/workflows/pages.yml`：permissions（pages write + id-token）→ configure-pages@v5 → upload-pages-artifact@v3（path: docs）→ deploy-pages@v4，environment: github-pages
- `docs/index.html`：静态站点（构建/测试/质量门禁说明）
- ci.yml quality job 增加 shellcheck 步骤：`shellcheck -x scripts/*.sh`

## 验证结果
shellcheck 0.11.0 本地对 scripts/ 下 4 个脚本全部 PASS；两份工作流均通过 actionlint 校验。推送 master 后自动发布到 Pages（需在仓库 Settings 把发布源设为 GitHub Actions）。

## 对应提交
- 8503c01 feat(ci): CI增加shellcheck脚本检查步骤
- 74a7e54 feat(ci): 新增GitHub Pages部署工作流与静态站点
