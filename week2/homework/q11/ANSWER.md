# 练习11: dotfiles 项目

## 练习要求
1. 为 dotfiles 建一个目录，并纳入版本控制；
2. 至少为一个程序加入配置（例如通过 `$PS1` 定制 shell prompt）；
3. 配置一种方法，让新机器能快速自动安装 dotfiles（如 `ln -s` 脚本）；
4. 在一台全新机器上测试安装脚本；
5. 把工具配置迁移进 dotfiles 仓库；
6. 发布到 GitHub。

## 本练习完成内容

**dotfiles/ 目录**（已被 git 跟踪，属于版本控制）：
- `.bashrc` — 定制 `PS1`：`\[\e[1;32m\]\u@\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ `（绿色 user@host + 蓝色当前目录）
- `.bash_aliases` — 迁移自 q10 的常用别名
- `.gitconfig` — git 用户、颜色、编辑器
- `.vimrc` — vim 基础配置
- `install.sh` — 对每个文件执行 `ln -s`，已有文件先备份

**install.sh 关键逻辑**
```bash
for f in .bashrc .bash_aliases .gitconfig .vimrc; do
  if [ -e "$HOME/$f" ] && [ ! -L "$HOME/$f" ]; then
    mv "$HOME/$f" "$BACKUP_DIR/"      # 不覆盖已有配置
  fi
  ln -sfn "$DOTFILES_DIR/$f" "$HOME/$f"
done
```

**新机器测试**：solve.sh 用 `mktemp -d` 造一个全新 `HOME`，以 `HOME=<新目录> bash install.sh` 运行安装脚本，验证符号链接成功生成，再 `source` 确认 `PS1` 已生效。

## 发布到 GitHub（本机无凭据，记录步骤）
```bash
git remote add origin https://github.com/<user>/dotfiles.git
git push -u origin main
```
之后任意新机器 `git clone` + `bash install.sh` 即可复现环境。课程作业中，dotfiles 随主仓库一并推送 GitHub 即可（见 README.md）。

## 实测结果
output.txt 中：install.sh 在全新 HOME 下逐个建立符号链接 → 4 个 dotfile 链接就位 → `source .bashrc` 后 PS1 变量包含定制序列 → git 确认文件被跟踪。
