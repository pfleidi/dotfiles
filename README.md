# Dotfiles

This repository manages a small macOS development environment with mise:

- Ghostty
- Herdr with Claude Code and Codex integrations
- Neovim with LazyVim, Go support, and CodeDiff
- Vim as a lightweight plugin-free fallback
- Go, gopls, ripgrep, delta, Hunk, fd, and Tree-sitter
- LazyGit and Git LFS
- Oh My Zsh, Starship, direnv, and tmux
- explicit Zsh, Git, LazyGit, Herdr, Vim, Neovim, and mise links

The checked-in LazyVim lockfile pins editor plugin versions.

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

Bootstrap is convergent: packages, repositories, and links already in the declared state are left alone. Mise installs or safely updates a clean `~/.oh-my-zsh` checkout from its official repository and refuses a conflicting or locally modified checkout. Oh My Zsh's own updater is disabled so mise remains its only update path. The final `bootstrap` task re-applies Herdr's Claude and Codex integrations; Herdr's install command is idempotent. It never logs either agent in.

Do not use `--force-dotfiles`. If a destination conflicts, stop and move it under:

```text
~/.local/state/dotfiles-backups/<timestamp>/
```

Then rerun the dry-run.

## Updates

Bootstrap installs missing packages; it does not upgrade everything. Updates are explicit:

```sh
mise run update
```

The task updates managed repositories and declared Homebrew packages, synchronizes LazyVim plugins, runs verification, and leaves every change visible to Git. It never commits or pushes.

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

## Package inventory

The bootstrap package list is the minimal development environment. The Brewfile is the complete machine inventory of Homebrew, Go, and npm packages; normal bootstrap does not apply it.

```sh
mise run brew-install
mise run brew-dump
```

`brew-install` installs missing Brewfile entries without upgrading installed packages. `brew-dump` replaces the Brewfile with a snapshot of the current machine. Neither task removes packages.

## References

- [mise bootstrap](https://mise.jdx.dev/bootstrap.html)
- [mise dotfiles](https://mise.jdx.dev/dotfiles.html)
- [LazyVim installation](https://www.lazyvim.org/installation)
- [LazyVim Go extra](https://www.lazyvim.org/extras/lang/go)
- [CodeDiff.nvim](https://github.com/esmuellert/codediff.nvim)
- [Herdr keyboard guide](https://herdr.dev/docs/keyboard/)
- [Herdr agent automation](https://herdr.dev/docs/agent-automation/)
