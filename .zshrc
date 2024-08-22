#!/bin/zsh

# Check if interactive shell
iatest=$(expr index "$-" i)

# Source global definitions (Zsh doesn't typically use /etc/bashrc, but you can include it if needed)
if [ -f /etc/zshrc ]; then
    . /etc/zshrc
fi

# Enable Zsh completion system (similar to bash-completion)
autoload -Uz compinit
compinit

# EXPORTS

# NVM export
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion (optional)

# Starship config
export STARSHIP_CONFIG=~/.config/starship.toml

# Disable the bell
if [[ $iatest -gt 0 ]]; then bindkey -e; unsetopt BEEP; fi

# Expand the history size
export HISTFILESIZE=10000
export HISTSIZE=500

# Don't put duplicate lines in the history and do not add lines that start with a space
export HISTCONTROL=erasedups:ignoredups:ignorespace

# Zsh equivalent of checkwinsize (automatically enabled)
# No need to set anything for this in Zsh

# Append to the history file, rather than overwriting it
setopt APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS

# Ignore case on auto-completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Show auto-completion list automatically, without double tab
setopt AUTO_LIST
zstyle ':completion:*' list-suffixes

# Set the default editor
export EDITOR=nvim
export VISUAL=nvim

# To have colors for ls and all grep commands such as grep, egrep, and zgrep
export CLICOLOR=1
export LS_COLORS='no=00:fi=00:di=00;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:*.xml=00;31:'

# Color for manpages in less makes manpages a little easier to read
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# Aliases
alias home="cd ~"
alias diskspace="du -S | sort -n -r | more"
alias tree='tree -CAhF --dirsfirst'

export PATH=$PATH:"$HOME/.local/bin:$HOME/.cargo/bin:/var/lib/flatpak/exports/bin:/.local/share/flatpak/exports/bin"
export PATH=$PATH:/usr/local/go/bin

# Activate starship
eval "$(starship init zsh)"
