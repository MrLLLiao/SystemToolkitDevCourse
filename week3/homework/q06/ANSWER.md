# 练习6: 用 GitHub Pages 做网站（额外项：自定义域名）

## 练习要求
用 GitHub Pages 做一个网站；额外（非计分）项：配置自定义域名。

## 网站设计（q06/site/）
一个纯静态个人主页：`index.html`（个人介绍 + week3 作业索引 + "GitHub Pages 工作原理"说明）+ `style.css`（渐变 hero、卡片式布局）。刻意不使用任何框架/构建工具——GitHub Pages 托管的就是这类"零构建"静态文件。

## GitHub Pages 的三种发布方式
| 方式 | 说明 |
|---|---|
| `gh-pages` 分支 | 项目页经典方式：把站点文件放在独立分支根目录 |
| `/docs` 目录 | 在 main 分支放一个 docs/ 目录 |
| GitHub Actions | 官方推荐：工作流构建产物 → `actions/deploy-pages` 发布 |

本次采用**gh-pages 分支**方式（最经典、最能说明机制）。

## 执行过程（solve.sh 自动复现，见 output.txt）
1. **本地验证**：`python3 -m http.server 8123` 起站，`curl` 得到 **HTTP 200**，页面标题 `廖世嘉 · 系统开发工具基础`、学号 `25020007073` 均在 HTML 中正确渲染。
2. **演示发布机制**（deploy.sh）：用 `git worktree add --orphan -b gh-pages` 在仓库里创建独立的 gh-pages 孤儿分支，只复制站点文件并提交：
   ```
   >>> gh-pages 分支内容:
   index.html
   style.css
   ```
   分支里只有站点文件、无任何历史包袱；`git worktree` 保证发布过程不打断 main 分支的工作区。
3. **真实发布（需 GitHub 凭据，本机未配置）**：
   ```bash
   git push -u origin gh-pages
   ```
   然后在 GitHub 仓库 `Settings → Pages → Branch: gh-pages / (root)` 保存，站点即发布到 `https://mrllliao.github.io/SystemToolkitDevCourse/`。

> 调试收获：第一次 deploy.sh 用 `rm -rf "$WORK"/.[!.]*` 清残留，把 orphan worktree 的 `.git` 文件也删了，导致 `not a git repository`；而 orphan worktree 每次本就是全新空目录，根本不需要清残留，删掉那行即修复。`git worktree add --orphan` 是给 Pages 建干净孤儿分支的利器。

## 额外项：自定义域名
1. 在站点根目录放一个 `CNAME` 文件，内容为你的域名，如 `example.com`；
2. 去域名注册商/DNS 处加一条解析：`CNAME example.com → mrllliao.github.io`（若为裸域名用 A 记录指向 `185.199.108.153` 等 Pages IP）；
3. GitHub `Settings → Pages → Custom domain` 填域名保存，开启 Enforce HTTPS。
（本练习不实际购买域名，因此不写 CNAME 占位文件，避免误导。）

## 收获
- GitHub Pages = 免费静态托管，适合个人主页/项目文档/作品集；"静态网站"理解的核心是：内容即文件、无服务器端逻辑；
- 用 `git worktree` + 孤儿分支做发布，能把"发布分支"与"开发分支"彻底隔离，且不影响工作区；
- 一次"本地起站 + curl 验证"就能在 push 之前确认站点内容正确——发布前自检的通用模式。

## 验证
- `output.txt` 完整记录；重跑 `bash solve.sh` 可复现。
- 已确认：本地 HTTP 200、标题/学号正确渲染、gh-pages 分支只含站点文件、main 工作区未被污染（`git status` 仅显示待提交的 q06 文件）。
## 真实发布记录（补充，2026-08-31）
在用户提供 GitHub 令牌后，完成**GitHub Pages 真实上线**：
- `git push origin gh-pages` 成功（远端新建 gh-pages 分支，仅含 index.html + style.css）；
- 经 REST API 确认 Pages 已启用：`source=gh-pages/`、status=built、https_enforced=true；
- 站点地址 `https://mrllliao.github.io/SystemToolkitDevCourse/` 访问返回 HTTP 200，
  标题"廖世嘉 · 系统开发工具基础"正确渲染。
- 真实 push 前须先修本机 git 代理（`git config --global http.proxy http://172.26.224.1:7890`）。