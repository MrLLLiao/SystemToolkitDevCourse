#!/bin/bash
# q06: 把 site/ 发布到本地 gh-pages 分支（GitHub Pages 经典方式）
# 说明：最终一步 git push origin gh-pages 需要 GitHub 凭据（本机未配置）。
# 脚本会完成"本地分支就绪"，并打印需你补充执行的推送命令。
# 每次运行都删除并重建 gh-pages 孤儿分支：orphan worktree 是全新空目录，
# 因此直接复制站点文件即可，保证分支里只有站点内容。
set -eu
REPO=/root/gitRepo/SystemToolkitDevCourse
SITE="$REPO/week3/homework/q06/site"
WORK=/root/week3_hw/q06-ghpages

cd "$REPO"
git worktree remove "$WORK" --force >/dev/null 2>&1 || true
git worktree prune >/dev/null 2>&1 || true
rm -rf "$WORK"
git branch -D gh-pages >/dev/null 2>&1 || true
git worktree add --orphan -b gh-pages "$WORK" >/dev/null
cp -r "$SITE"/. "$WORK"/
cd "$WORK"
git add -A
git commit -q -m "docs(homework-q06): GitHub Pages 站点发布"
cd "$REPO"
git worktree remove "$WORK" --force >/dev/null
echo ">>> gh-pages 分支内容:"
git ls-tree --name-only gh-pages
echo ""
echo ">>> 下一步（需 GitHub 凭据，本机未配置，请获得 token 后执行）："
echo "    git push -u origin gh-pages"
echo "    然后在 GitHub 仓库 Settings -> Pages -> Branch: gh-pages / (root) 保存，站点即发布。"