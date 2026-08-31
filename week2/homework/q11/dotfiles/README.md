# dotfiles

个人 dotfiles 仓库：集中管理 shell 与常用工具的配置，用符号链接快速安装到新机器。

## 内容

| 文件 | 说明 |
|------|------|
| `.bashrc` | bash 配置，含自定义 `PS1` 提示符（绿色 `user@host` + 蓝色路径） |
| `.bash_aliases` | 常用别名（`dc`、`ll`、`gs`、`ga`、`gcm`、`py`） |
| `.gitconfig` | git 用户信息与颜色/编辑器设置 |
| `.vimrc` | vim 基础配置（语法高亮、行号、缩进） |
| `install.sh` | 一键安装脚本（对每个文件 `ln -s` 到 `$HOME`，旧配置自动备份） |

## 安装（新机器）

```bash
git clone <repo-url> ~/dotfiles
cd ~/dotfiles && bash install.sh
source ~/.bashrc
```

install.sh 会在 `$HOME` 下建立指向本目录的符号链接；若已有同名真实文件则先移动到 `~/.dotfiles_backup_<时间戳>/`，不会覆盖丢失。

## 版本控制与发布

- 本目录已纳入 git 版本控制（当前作为课程仓库的一部分；生产环境可独立成仓）。
- 发布到 GitHub：在 GitHub 新建仓库后，
  ```bash
  git remote add origin https://github.com/<user>/dotfiles.git
  git push -u origin main
  ```
  之后任意新机器 `git clone` + `bash install.sh` 即可复现环境。

## 测试

`solve.sh` 用全新 `HOME` 目录模拟新机器运行 `install.sh`，验证符号链接生成与 `PS1`/别名内容（见 output.txt）。
