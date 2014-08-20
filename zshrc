# options below can be overridden in ~/.zshrc.local

# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh

# Set to the name theme to load.
# Look in ~/.oh-my-zsh/themes/
export ZSH_THEME="kennethreitz"

# Set to this to use case-sensitive completion
export CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
export DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# export DISABLE_LS_COLORS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
plugins=(git osx brew brew-cask ruby gem bundler zsh-syntax-highlighting)

# Needs https://github.com/zsh-users/zsh-syntax-highlighting/
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

# Locale settings (utf-8)
export LC_CTYPE=en_US.UTF-8
export LANG=en_US.UTF-8

# load ~/.zshrc.local
[[ -s $HOME/.zshrc.local ]] && source "$HOME/.zshrc.local"

# load oh-my-zsh
source $ZSH/oh-my-zsh.sh

# ============== Custom tweaks below this line ==============

# Aliases
source $HOME/.zsh/aliases.zsh
# Key Bindings
source $HOME/.zsh/keybindings.zsh

#History Settings
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=$HISTSIZE

# completion cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# ignore duplicate entries
setopt hist_ignore_all_dups
setopt hist_ignore_space

# Load ENV Variables
export EDITOR=vim
export PAGER=less

# Put custom $PATH settings into ~/.zprofile or ~/.zshrc.local
export PATH=$PATH:$HOME/.bin

#077 would be more secure, but 022 is generally quite realistic
umask 022

#Auto Escape URLS
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

# SSH Stuff
if [ -r $HOME/.ssh/config ]; then
  hosts=(`cat $HOME/.ssh/config | egrep '^Host.*' | sed "s/^Host[ ]*\(.*\)$/\1/"`)
fi
if [ -r /etc/hosts ]; then
  hosts=( $hosts $(cat /etc/hosts | grep -v '^\#' | awk '{print $2}') )
fi

zstyle '*' hosts $hosts
#zstyle ':completion:*:*:*:*:*' menu complete

# show fortune cookie
type fortune &>/dev/null && fortune -a
# load grc aliases for colored shell output
type grc &>/dev/null && source $HOME/.zsh/grc_aliases.zsh

# EOF
