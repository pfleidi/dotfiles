# Dotfiles

This repository manages a small macOS development environment with mise:

- Ghostty
- Herdr with Claude Code and Codex integrations
- Neovim with LazyVim, Go support, and CodeDiff
- Vim as a lightweight plugin-free fallback
- Go, gopls, ripgrep, fd, and Tree-sitter
- Oh My Zsh, Starship, direnv, and tmux
- explicit Zsh, Git, Herdr, Vim, Neovim, and mise links

The mise lockfile pins resolved tool versions and download metadata. The checked-in LazyVim lockfile does the same for editor plugins.

This repository deliberately does not manage credentials, agent sessions, SSH material, Neovim data/state/cache, Zed, every installed Homebrew package, or unrelated macOS preferences. It does not configure an editor AI plugin, debugger UI, Git difftool, mergetool, or visual merge tool.

## Fresh macOS setup

Start with Xcode Command Line Tools, which provide Git and a C compiler:

```sh
xcode-select --install
```

The command opens an Apple installation dialog when the tools are missing. Complete it before continuing.

Install Homebrew with its current official installer:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Load Homebrew in the current shell, then install mise. Homebrew uses `/opt/homebrew` on Apple Silicon and `/usr/local` on Intel Macs:

```sh
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  eval "$(/usr/local/bin/brew shellenv)"
fi
brew install mise
```

Mise must exist before this repository can bootstrap the rest of the machine. Clone the repository first and bootstrap from its real checkout path:

```sh
git clone https://github.com/pfleidi/dotfiles.git "$HOME/dotfiles"
cd "$HOME/dotfiles"

mise bootstrap --dry-run
mise bootstrap --yes
mise bootstrap status
mise run verify
```

The `$HOME/dotfiles` destination is only an example. Dotfile sources are relative to `mise.toml`, so the checkout can live anywhere.

## Existing checkout

Review the plan before applying it:

```sh
cd <dotfiles-checkout>
mise bootstrap --dry-run
mise bootstrap --yes
mise bootstrap status
mise run verify
```

`mise run setup` is an optional alias for `mise bootstrap --yes`. The native bootstrap command remains the source of truth.

Bootstrap is convergent: packages, repositories, links, and locked tools already in the declared state are left alone. Mise installs or safely updates a clean `~/.oh-my-zsh` checkout from its official repository and refuses a conflicting or locally modified checkout. Oh My Zsh's own updater is disabled so mise remains its only update path. The final `bootstrap` task re-applies Herdr's Claude and Codex integrations; Herdr's install command is idempotent. It never logs either agent in.

Do not use `--force-dotfiles`. If a destination conflicts, stop and move it under:

```text
~/.local/state/dotfiles-backups/<timestamp>/
```

Then rerun the dry-run.

## Updates

Bootstrap installs the locked versions; it does not upgrade everything. Updates are explicit:

```sh
mise run update
```

The task updates managed repositories, upgrades configured mise tools, refreshes the global lockfile, synchronizes LazyVim plugins, runs verification, and leaves every change visible to Git. It never commits or pushes.

## Local and private configuration

The public Git config includes this ignored machine-local file:

```text
~/.config/git/config.local
```

Use `config/git/config.local.example` as its shape. Identity and signing settings belong in the local file; this repository overrides its author email locally with the personal GitHub address.

`zsh/secrets.zsh` is also ignored and sourced only when present. Its longer-term replacement is intentionally postponed. Claude and Codex login state, tokens, session databases, and generated Herdr integration files stay outside this repository.

Zsh keeps completion state under `~/.cache/zsh`. Entire completion is regenerated only when the installed CLI is newer than the cached definition. Ruby version management is not initialized globally; use mise in Ruby projects or opt into rbenv from local shell configuration on machines that need it.

Starship uses the managed `~/.config/starship.toml` prompt configuration. Direnv has no global configuration; its official Oh My Zsh plugin provides the shell hook.

After a fresh bootstrap, run `claude` and `codex` interactively if either CLI still needs authentication.

## Rollback

Changes are kept in focused Git commits. Revert the unwanted commit, inspect the new plan, and reapply the declared state:

```sh
git revert <commit>
mise bootstrap --dry-run
mise bootstrap --yes
mise run verify
```

Mise converges declared links but does not remove a link whose declaration disappeared in a reverted commit. Inspect such a destination before removing or relinking it. Backed-up symlinks can be restored with `cp -P` from the backup directory.

## First day

### Start a project workspace

```sh
cd <project>
herdr
```

Keep Neovim in one pane, Codex or Claude in another, and tests, logs, or a second agent in the remaining panes.

### LazyVim navigation

| Action | Key |
| --- | --- |
| Find files | `Space Space` |
| Grep project | `Space /` |
| Explorer | `Space e` |
| Document symbols | `Space s s` |
| Workspace symbols | `Space s S` |
| Definition | `g d` |
| References | `g r` |
| Implementation | `g I` |

LazyVim's default Snacks picker and explorer provide these functions. No Telescope, fzf-lua, or neo-tree replacement is configured.

Neovim checks for external changes after `CursorHold`. A clean buffer reloads; an unsaved buffer keeps its edits and shows Neovim's conflict warning. LazyVim uses the macOS clipboard through `unnamedplus` in a normal UI session.

### Vim fallback

Vim uses its built-in fuzzy completion, file explorer, commenting, EditorConfig, and extended `%` matching. Ripgrep fills the quickfix list.

| Action | Key |
| --- | --- |
| Find a file | `Space Space` |
| Enter a project search | `Space /` |
| Search for the word under the cursor | `Space g` |
| Explorer | `Space e` |
| Open quickfix | `Space q` |
| Previous/next quickfix item | `[q` / `]q` |

### Herdr navigation

```text
Ctrl-H/J/K/L        Neovim windows
Ctrl-Alt-H/J/K/L    Herdr panes
F12                 Herdr prefix
```

Press `F12`, then `?` for Herdr's active key map.

### Review branch changes

Use the real base for the current repository: `main`, `master`, a release branch, or an upstream remote branch.

```vim
:CodeDiff <base>...
:CodeDiff <base>...HEAD
:CodeDiff history <base>..HEAD --reverse
```

| Action | Key |
| --- | --- |
| Previous/next change | `[c` / `]c` |
| Previous/next file | `[f` / `]f` |
| Toggle inline/side-by-side | `t` |
| Open the real working file | `gf` |
| Close | `q` |

Historical Git buffers are snapshots and may not have a live LSP client. Use `gf` to open the corresponding working file for gopls navigation.

For agent-made commits, ask the agent to create small coherent commits, then review them oldest-first. Commit behavior remains controlled by the prompt given to that agent; this setup does not enable automatic commits globally.

### Ask the running agent

```sh
herdr agent list
herdr agent prompt <target> "<question>"
```

Use the agent name shown by `herdr agent list` as `<target>`. The prompt command talks to the existing interactive agent rather than starting a second conversation.

## Managed links

Mise owns only these destinations:

```text
~/.config/mise/config.toml
~/.config/mise/tasks
~/.config/nvim
~/.config/herdr/config.toml
~/.config/git/config
~/.config/starship.toml
~/.vimrc
~/.tmux.conf
~/.zprofile
~/.zshrc
~/.zsh
```

It does not link all of `~/.config` or turn every repository-root file into a home dotfile.

## Package inventory

The Brewfile records what Homebrew, Go, and npm reported as installed on this machine. Nothing in it is automatically installed, upgraded, or removed by mise.

- `mise` is the bootstrap prerequisite.
- Ghostty, tmux, Vim, and Zsh syntax highlighting are native packages.
- Go, gopls, Neovim, ripgrep, fd, Tree-sitter, Starship, direnv, Herdr, Claude Code, and Codex are mise tools.
- Everything else in the Brewfile is inventory only and remains outside this setup.

## References

- [mise bootstrap](https://mise.jdx.dev/bootstrap.html)
- [mise dotfiles](https://mise.jdx.dev/dotfiles.html)
- [LazyVim installation](https://www.lazyvim.org/installation)
- [LazyVim Go extra](https://www.lazyvim.org/extras/lang/go)
- [CodeDiff.nvim](https://github.com/esmuellert/codediff.nvim)
- [Herdr keyboard guide](https://herdr.dev/docs/keyboard/)
- [Herdr agent automation](https://herdr.dev/docs/agent-automation/)
