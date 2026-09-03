typeset -U path PATH fpath FPATH
path=("$HOME/.local/bin" $path)
path+=("$HOME/go/bin" "$HOME/.bin")

[[ -n ${HOMEBREW_PREFIX:-} && -d "$HOMEBREW_PREFIX/share/zsh/site-functions" ]] && fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

# options below can be overridden in ~/.zshrc.local

# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh

zsh_cache_dir=${XDG_CACHE_HOME:-$HOME/.cache}/zsh
[[ -d $zsh_cache_dir/oh-my-zsh ]] || mkdir -p "$zsh_cache_dir/oh-my-zsh"
ZSH_CACHE_DIR=$zsh_cache_dir/oh-my-zsh
ZSH_COMPDUMP=$zsh_cache_dir/.zcompdump-$HOST-$ZSH_VERSION
unset zsh_cache_dir

CASE_SENSITIVE="true"

zstyle ':omz:update' mode disabled

if [[ $OSTYPE == darwin* ]]; then
  plugins=(git brew ssh-agent kubectl tmux direnv)
  zstyle ':omz:plugins:ssh-agent' lazy yes
else
  plugins=(git kubectl tmux direnv)
fi

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

# Locale settings (utf-8)
if [[ $OSTYPE == darwin* ]]; then
  export LC_CTYPE=en_US.UTF-8
  export LANG=en_US.UTF-8
else
  export LC_CTYPE=C.UTF-8
  export LANG=C.UTF-8
fi

# load ~/.zshrc.local
[[ -s $HOME/.zshrc.local ]] && source "$HOME/.zshrc.local"

# load oh-my-zsh
[[ -r $ZSH/oh-my-zsh.sh ]] && source "$ZSH/oh-my-zsh.sh"

# ============== Custom tweaks below this line ==============

for zsh_rc in "$HOME"/.zsh/*.zsh(N); do
  source "$zsh_rc"
done
unset zsh_rc

#History Settings
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=$HISTSIZE

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/cache"

# ignore duplicate entries
setopt hist_ignore_all_dups
setopt hist_ignore_space

# Load ENV Variables
export EDITOR=nvim
export PAGER=less
export LESS=-R

#077 would be more secure, but 022 is generally quite realistic
umask 022

#Auto Escape URLS
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"
if [[ -n ${HOMEBREW_PREFIX:-} && -r "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
elif [[ -r /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# EOF
