typeset -U path PATH fpath FPATH
path=("$HOME/.local/bin" $path)
path+=("$HOME/go/bin" "$HOME/.bin")

[[ -d "$HOMEBREW_PREFIX/share/zsh/site-functions" ]] && fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

# options below can be overridden in ~/.zshrc.local

# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh

zsh_cache_dir=${XDG_CACHE_HOME:-$HOME/.cache}/zsh
if [[ ! -d $zsh_cache_dir/oh-my-zsh || ! -d $zsh_cache_dir/completions ]]; then
  mkdir -p "$zsh_cache_dir/oh-my-zsh" "$zsh_cache_dir/completions"
fi
ZSH_CACHE_DIR=$zsh_cache_dir/oh-my-zsh
ZSH_COMPDUMP=$zsh_cache_dir/.zcompdump-$HOST-$ZSH_VERSION

entire_completion=$zsh_cache_dir/completions/_entire
if (( $+commands[entire] )) && [[ ! -s $entire_completion || $commands[entire] -nt $entire_completion ]]; then
  entire_completion_tmp=$entire_completion.$$
  if entire completion zsh >| "$entire_completion_tmp"; then
    mv "$entire_completion_tmp" "$entire_completion"
  else
    rm -f "$entire_completion_tmp"
  fi
fi
fpath=("$zsh_cache_dir/completions" $fpath)
unset entire_completion entire_completion_tmp zsh_cache_dir

CASE_SENSITIVE="true"

zstyle ':omz:update' mode disabled

plugins=(git brew ssh-agent kubectl tmux direnv)

zstyle ':omz:plugins:ssh-agent' lazy yes

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

# Locale settings (utf-8)
export LC_CTYPE=en_US.UTF-8
export LANG=en_US.UTF-8

# load ~/.zshrc.local
[[ -s $HOME/.zshrc.local ]] && source "$HOME/.zshrc.local"

# load oh-my-zsh
[[ -r $ZSH/oh-my-zsh.sh ]] && source "$ZSH/oh-my-zsh.sh"

# ============== Custom tweaks below this line ==============

# Aliases
[[ -r $HOME/.zsh/aliases.zsh ]] && source "$HOME/.zsh/aliases.zsh"
# Key Bindings
[[ -r $HOME/.zsh/keybindings.zsh ]] && source "$HOME/.zsh/keybindings.zsh"
[[ -r $HOME/.zsh/secrets.zsh ]] && source "$HOME/.zsh/secrets.zsh"

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
[[ -r "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# EOF
