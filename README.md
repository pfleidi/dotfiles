# Dotfiles

This repository manages a small macOS development environment with mise:

- Ghostty
- Herdr with Claude Code and Codex integrations
- Neovim with LazyVim, Go support, and CodeDiff
- Go, gopls, ripgrep, fd, and Tree-sitter
- explicit Zsh, Git, Herdr, Neovim, and mise links

The mise lockfile pins resolved tool versions and download metadata. The checked-in LazyVim lockfile does the same for editor plugins.

This repository deliberately does not manage credentials, agent sessions, SSH material, Neovim data/state/cache, Zed, Oh My Zsh itself, every installed Homebrew package, or unrelated macOS preferences. It does not configure an editor AI plugin, debugger UI, Git difftool, mergetool, or visual merge tool.

## Prerequisites

Mise must already be installed because it cannot bootstrap itself. macOS also needs Xcode Command Line Tools for Git and a C compiler:

```sh
xcode-select --install
curl https://mise.run | sh
```

The Xcode command opens an Apple installation dialog when the tools are missing. Complete that dialog before continuing.

Current mise no longer supports the older `mise bootstrap --from ...` flags. Clone the repository first, then bootstrap from its real checkout path:

```sh
git clone https://github.com/pfleidi/dotfiles.git "$HOME/dotfiles"
cd "$HOME/dotfiles"

~/.local/bin/mise bootstrap --dry-run
~/.local/bin/mise bootstrap --yes
~/.local/bin/mise bootstrap status
~/.local/bin/mise run verify
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

Bootstrap is convergent: packages, links, and locked tools that are already present are left alone. The final `bootstrap` task re-applies Herdr's Claude and Codex integrations; Herdr's install command is idempotent. It never logs either agent in.

Do not use `--force-dotfiles` during migration. If a destination conflicts, stop and move it under:

```text
~/.local/state/dotfiles-backups/<timestamp>/
```

Then rerun the dry-run. The current migration backup is `~/.local/state/dotfiles-backups/20260828-140334/`.

## Updates

Bootstrap installs the locked versions; it does not upgrade everything. Updates are explicit:

```sh
mise run update
```

The task upgrades configured mise tools, refreshes the global lockfile, synchronizes LazyVim plugins, runs verification, and leaves every change visible to Git. It never commits or pushes.

## Local and private configuration

The public Git config includes this ignored machine-local file:

```text
~/.config/git/config.local
```

Use `config/git/config.local.example` as its shape. Identity and signing settings belong in the local file; this repository overrides its author email locally with the personal GitHub address.

`zsh/secrets.zsh` is also ignored and sourced only when present. Its longer-term replacement is intentionally postponed. Claude and Codex login state, tokens, session databases, and generated Herdr integration files stay outside this repository.

After a fresh bootstrap, run `claude` and `codex` interactively if either CLI still needs authentication.

## Rollback

Each migration concern is kept in a focused Git commit. Revert the unwanted commit, inspect the new plan, and reapply the declared state:

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
~/.zshrc
~/.zsh
```

It does not link all of `~/.config` or turn every repository-root file into a home dotfile.

## Legacy configuration

The old broad `bootstrap.sh` is deleted. `Brewfile` is an installed-package snapshot, not an active bootstrap input. Vundle is not installed or updated by mise. The old Vim files remain available during the Neovim transition, but Neovim is the default editor.

The migration intentionally removed unused GNU Screen, IRB, RSpec, RVM, and Silver Searcher configuration. The small `gemrc` remains for possible Ruby work on another machine. No old Vim mappings or preferences were copied into LazyVim; candidates to reconsider later include relative line numbers, search highlighting preferences, and any frequently missed text-editing mappings.

## Brewfile audit

The Brewfile records what Homebrew, Go, and npm reported as installed on this machine. Nothing in it is automatically installed, upgraded, or removed by mise.

- Required bootstrap ownership: `mise` remains the prerequisite; `ghostty` is declared as the native cask.
- Replaced by mise: `go`, `herdr`, `ripgrep`, `claude`, `claude-code@latest`, `codex`, and `golang.org/x/tools/gopls`. Existing Homebrew/cask/Go copies remain installed but are shadowed after shell activation.
- Retained but unrelated to this migration: `direnv`, `gh`, `git`, `git-delta`, `golangci-lint`, `rbenv`, `starship`, `tmux`, `vim`, `zsh`, `zsh-syntax-highlighting`, `1password-cli`, and the Entire CLI/tap entries.
- Installed but deliberately not activated by this setup: `fzf`, `lazygit`, `github.com/go-delve/delve/cmd/dlv`, and `gotest.tools/gotestsum`.
- Left unresolved and untouched: `anomalyco/tap`, `docker/tap`, `awscli`, `cloudflared`, `colima`, `curl`, `fish`, `node`, `gemini-cli`, `htop`, `jq`, `libyaml`, `mkcert`, `mysql`, `ossp-uuid`, `pnpm`, `postgresql@14`, `redis`, `rust`, `shellcheck`, `tree`, `wget`, `yq`, `anomalyco/tap/opencode`, `arc`, `cloudflare-warp`, `copilot-cli`, `firefox`, `gcloud-cli`, `gemini`, `google-chrome`, `insomnia`, `iterm2`, `keepingyouawake`, `linear`, `obsidian`, `opencode-desktop`, `rectangle`, `docker/tap/sbx`, `slack`, `golang.org/x/tools/cmd/deadcode`, `@mariozechner/pi-coding-agent`, and the work-specific `entire.io` Go commands.

The unresolved group is inventory, not a recommendation. Redundant installations can be reviewed and removed separately.

## References

- [mise bootstrap](https://mise.jdx.dev/bootstrap.html)
- [mise dotfiles](https://mise.jdx.dev/dotfiles.html)
- [LazyVim installation](https://www.lazyvim.org/installation)
- [LazyVim Go extra](https://www.lazyvim.org/extras/lang/go)
- [CodeDiff.nvim](https://github.com/esmuellert/codediff.nvim)
- [Herdr keyboard guide](https://herdr.dev/docs/keyboard/)
- [Herdr agent automation](https://herdr.dev/docs/agent-automation/)
