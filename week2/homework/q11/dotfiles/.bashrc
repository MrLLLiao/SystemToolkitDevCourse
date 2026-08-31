# dotfiles 示例 .bashrc
# 1) 自定义 PS1: 绿色用户名@主机名 : 蓝色当前目录 $
PS1='\[\e[1;32m\]\u@\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ '

# 2) 加载别名文件
[ -f ~/.bash_aliases ] && source ~/.bash_aliases

# 3) 常用环境设置
export EDITOR=vim
alias c='clear'
