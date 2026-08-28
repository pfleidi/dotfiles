# Entire CLI: cached completions, cd-on-create wrapper, wt shorthand

(( $+commands[entire] )) || return 0

entire_completion_dir=${XDG_CACHE_HOME:-$HOME/.cache}/zsh/completions
[[ -d $entire_completion_dir ]] || mkdir -p "$entire_completion_dir"

entire_cache_completion() {
  local target=$entire_completion_dir/$1 tmp
  shift
  if [[ ! -s $target || $commands[entire] -nt $target ]]; then
    tmp=$target.$$
    if entire "$@" >| "$tmp"; then
      mv "$tmp" "$target"
    else
      rm -f "$tmp"
    fi
  fi
}
entire_cache_completion _entire completion zsh
entire_cache_completion _entire-worktree worktree completion zsh
unfunction entire_cache_completion

fpath=("$entire_completion_dir" $fpath)
autoload -Uz _entire _entire-worktree
if (( $+functions[compdef] )); then
  compdef _entire entire
  compdef _entire-worktree wt
fi
unset entire_completion_dir

eval "$(entire worktree shell-init zsh)"
wt() { entire worktree "$@"; }
