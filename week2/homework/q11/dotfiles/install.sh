#!/usr/bin/env bash
# dotfiles 安装脚本: 在 $HOME 下为每个 dotfile 建立符号链接 (ln -s)
# 新机器上 clone 本仓库后运行: bash install.sh
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d%H%M%S)"
mkdir -p "$BACKUP_DIR"

# 需要安装的 dotfile 清单
FILES=".bashrc .bash_aliases .gitconfig .vimrc"

for f in $FILES; do
  # 若目标已存在且不是符号链接, 先备份
  if [ -e "$HOME/$f" ] && [ ! -L "$HOME/$f" ]; then
    mv "$HOME/$f" "$BACKUP_DIR/"
    echo "备份原有 $HOME/$f -> $BACKUP_DIR/"
  fi
  ln -sfn "$DOTFILES_DIR/$f" "$HOME/$f"
  echo "链接 $HOME/$f -> $DOTFILES_DIR/$f"
done

echo ""
echo "安装完成。旧配置备份目录: $BACKUP_DIR"
