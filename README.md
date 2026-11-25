# Dotfiles

This repository manages a macOS-first development environment with mise. Shared
configuration also supports Ubuntu and Debian-based Linux machines without
changing the macOS package and configuration defaults.

The checked-in LazyVim lockfile pins editor plugin versions.

`mise.toml` contains shared state. Mise automatically adds `mise.macos.toml` or
`mise.linux.toml` through the managed global `miserc.toml`. macOS remains the
primary setup and keeps Homebrew ownership of its packages. The Linux layer uses
apt for system dependencies and mise for versioned command-line tools.

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

Mise must exist before this repository can bootstrap the rest of the machine.
GitHub SSH access must also be configured so bootstrap can clone the private
`pfleidi/skills` repository. Clone this repository and bootstrap from its real
checkout path:

```sh
git clone https://github.com/pfleidi/dotfiles.git "$HOME/dotfiles"
cd "$HOME/dotfiles"

MISE_AUTO_ENV=true mise bootstrap --dry-run
MISE_AUTO_ENV=true mise bootstrap --yes
mise bootstrap status
mise run verify
```

The `$HOME/dotfiles` destination is only an example. Dotfile sources are relative to `mise.toml`, so the checkout can live anywhere.
The first bootstrap installs OrbStack when it is missing. Open the OrbStack app
once afterward to finish its setup.

## Existing checkout

Review the plan before applying it:

```sh
cd <dotfiles-checkout>
MISE_AUTO_ENV=true mise bootstrap --dry-run
MISE_AUTO_ENV=true mise bootstrap --yes
mise bootstrap status
mise run verify
```

Bootstrap is convergent: packages, repositories, and links already in the
declared state are left alone. Mise installs or safely updates clean Oh My Zsh
and private skills checkouts and refuses conflicting or locally modified
checkouts. Oh My Zsh's own updater is disabled so mise remains its only update
path. The final `bootstrap` task refreshes the local Claude plugin and reapplies
Herdr's Claude and Codex integrations. It never logs either agent in.

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

The task updates managed repositories and declared platform packages, synchronizes LazyVim plugins, runs verification, and leaves every change visible to Git. It never commits or pushes.

## Worktrees

Worktrunk creates worktrees under
`~/worktrees/<repository path | sanitize_hash>/<branch | sanitize>`. Mise renders
the home prefix per machine; repository paths are home-relative when possible,
otherwise absolute. Existing worktrees keep their locations.

Each worktree Worktrunk creates gets a `tmp/` directory for scratch files. When
no ignore rule covers it, a `pre-start` hook appends `/tmp/` to the repository's
`.git/info/exclude`, which applies to the main checkout and all its worktrees.
The hook fails when `tmp` exists and is not a directory.

Mise trusts a config in a worktree when the same path in the repository's main
checkout is trusted, so new worktrees need no separate `mise trust`.

## Daily task board

The `today` command runs `kanban-md` against the same local board from any
working directory. Initialize the board once:

```sh
today init --name Today --statuses planned,in-progress,blocked,done --wip-limit in-progress:1
```

The board lives at `~/.local/share/kanban-md/today`. Open its live terminal
view or use any regular `kanban-md` command through the wrapper. This is a
personal action list, not work intake for coding agents:

```sh
today tui
today list
today board
```

## Herdr agent launcher

`herdr-agent` requires Python 3 and Herdr and is available through the managed
`~/.bin` link. Dispatch a fresh agent into an existing task workspace:

```sh
herdr-agent dispatch --workspace "$task_workspace" --cwd "$worktree" \
  --phase implementation --prompt-file "$handoff"
```

Use `--new-workspace 'Task label'` instead of `--workspace` for a new workspace.
The first phase uses its root tab; existing workspaces receive a new phase tab.
Implementation tabs include a human-owned shell to the right at the same working
directory. All creation preserves focus. Resume existing agents and their shells
through Herdr rather than dispatching a duplicate.

The agent kind defaults to the live caller's Codex or Claude Code identity.
`--kind codex` or `--kind claude` overrides it. When inherited pane context is
unavailable, supply a verified `--caller-pane`, or an explicit kind with no caller.
The wrapper never discovers the caller through UI focus or switches providers
when launch fails. The caller supplies a verified task workspace and worktree;
task interpretation, tracker updates, and worktree creation belong to the agent.

Dispatch returns JSON with `workspace`, `tab`, `agent_pane`, `kind`, and an
implementation `shell_pane`. `status: delivered` confirms command delivery, not
agent readiness. Errors retain created IDs; `delivery_unknown` means submission
may have arrived. Inspect that destination before retrying. The wrapper leaves
created panes open and retains the original handoff. A private temporary copy
carries peer IDs and is consumed by the receiving launcher; an undelivered copy
is reported as `prompt_file` for recovery or cleanup.

For a manual launch inside an interactive Herdr pane:

```sh
herdr-agent --choose
herdr-agent --kind codex -- 'Review the current changes.'
herdr-agent --kind claude --prompt-file "$handoff"
```

`--choose` waits for an explicit choice among installed CLIs; `q`, Ctrl-C, or
end-of-input cancels. Each launch starts a fresh session in that pane, passing
the prompt unchanged as one argument. Login and agent settings remain managed
by each CLI. Use `herdr-agent dispatch --help` for dispatch options.

## Local and private configuration

The public Git config includes this ignored machine-local file:

```text
~/.config/git/config.local
```

Use `config/git/config.local.example` as its shape. Identity and signing settings belong in the local file; this repository overrides its author email locally with the personal GitHub address.

`zsh/secrets.zsh` is ignored and sourced only when present. Claude and Codex
login state, tokens, session databases, private global agent instructions,
skills, and generated Herdr integration files stay outside this repository.
Bootstrap links private instructions and skills without copying their contents
here.

Zsh keeps completion state under `~/.cache/zsh`. Ruby version management is not initialized globally; use mise in Ruby projects or opt into rbenv from local shell configuration on machines that need it.

Starship uses `~/.config/starship.toml` by default, with orange and yellow
Gruvbox accents. Alternative configurations live in `~/.config/starship/`.
To select one for a machine, add this to its `~/.zshrc.local`:

```zsh
export STARSHIP_CONFIG="$HOME/.config/starship/terracotta_teal.toml"
```

| Configuration | Username | Directory | Git |
| --- | --- | --- | --- |
| `~/.config/starship.toml` (default) | Orange | Yellow | Green |
| `terracotta_teal.toml` | Terracotta | Ochre | Teal |
| `copper_petrol.toml` | Copper | Mustard | Petrol |
| `olive_plum.toml` | Olive | Bronze | Plum |
| `teal_brick.toml` | Teal | Mustard | Brick |

The four named alternatives use cream segment text with at least 4.8:1
contrast. Their status symbols also meet 4.8:1 against the terminal background
`#282c34`; contrast depends on the background configured in your terminal.

Open a new shell to apply the choice, including an interactive SSH shell on
that machine. Leave `STARSHIP_CONFIG` unset for the default, or set it to
`$HOME/.config/starship.toml` to override an inherited choice. Each file is a
complete configuration; apply shared layout changes to all five files.

Direnv has no global configuration; its official Oh My Zsh plugin provides the shell hook.

After a fresh bootstrap, run `claude` and `codex` interactively if either CLI still needs authentication.

## 1Password CLI on Linux

Linux bootstrap installs `op`. Authenticate inside Linux rather than through
1Password for Mac:

```sh
op account add
eval "$(op signin)"
```

`op account add` is only needed the first time.

## Agentbox repository manifest

Generate the private repository manifest from an existing directory of Git
working trees:

```sh
agentbox sync-repos DIRECTORY
```

The command searches recursively, stops below each working tree, and writes
only normalized GitHub SSH remotes to `~/.config/agentbox/repos`. It rejects
unsupported or credential-bearing remotes and clone-directory collisions. A
failed scan leaves the previous manifest unchanged; the source directory is
not stored.

## Agentbox machine template

The versioned `config/agentbox/workbox.json` template selects the distribution,
architecture, CPU count, memory in MiB, and disk size in GiB. `agentbox create`
validates the file before touching OrbStack, uses it for new machines, and
reapplies its resource limits to an existing isolated machine without deleting
guest data. A distribution without a version, such as `ubuntu`, follows
OrbStack's current default release.

## Agentbox setup and maintenance

Agentbox runs on macOS with OrbStack initialized and `gh` authenticated through
its stored session. Generate the repository manifest above, then run:

```sh
agentbox create
agentbox shell
```

Creation provisions an isolated Ubuntu guest or reapplies the environment to
an existing compatible guest. It starts stopped guests and verifies the result.
The guest checks out this repository's published `master` branch at
`~/dotfiles`. Create, update, and rebuild apply that checkout's environment;
host branches and uncommitted files do not supply guest configuration.

Agentbox registers its dedicated GitHub key through the stored GitHub CLI
session and installs it in the guest at `~/.ssh/agentbox_ed25519`, mode `0600`.
Guest Git operations use that key with noninteractive authentication and pinned
GitHub host trust. Existing unrelated SSH configuration is retained; conflicting
managed files stop setup. Host mounts, SSH-agent forwarding, guest access to
the host network, and LAN port exposure remain disabled. The private repository
manifest remains host-local; maintenance does not update arbitrary project
checkouts. Run `claude` and `codex` interactively inside the guest for their
separate login flows when needed.

Run maintenance explicitly from macOS:

```sh
agentbox update
```

Update requires an existing guest and starts it if stopped. It first checks the
dotfiles origin, `master` branch, tracked edits, untracked files, and unpublished
commits. Only a clean checkout that can fast-forward to published `master`
proceeds to upgrades. Local changes and commits remain available for manual
resolution; agentbox does not stash, reset, clean, or commit them.

The shared application routine upgrades all installed Ubuntu packages within
the current release, updates mise itself, reapplies declared packages and
dotfiles, updates managed bootstrap repositories, and upgrades globally declared
tools within their configured ranges. Exact tool pins remain pinned. Agent
integrations are refreshed. Neovim installs and restores published locked plugin
commits, checks the installed revisions, and leaves the tracked lockfile intact.
The host's `mise run update` retains its separate plugin-update behavior.

Every successful update restarts `workbox`, retries SSH readiness up to twelve
times with a five-second connection timeout and two seconds between attempts,
then runs `mise run verify` and checks checkout cleanliness. It leaves the guest
running. Package service restarts and the final guest restart can interrupt
active sessions, so finish guest work before invoking maintenance. Updates are
manual; agentbox installs no scheduled maintenance job.

On failure, the command reports the failed phase and preserves the guest for
repair. Package operations are not transactional. Resolve the reported problem
and rerun `agentbox update`; failed application does not trigger the success-path
restart. A readiness or verification failure after restart also returns failure.

`agentbox rebuild` requires an interactive terminal and confirmation by typing
`workbox`. It permanently deletes all guest state, recreates the machine, and
repeats bootstrap and verification. Copy out work you need before rebuilding.

## Agentbox checks

Run the isolated suites from this repository using installed binaries on PATH:

```sh
tests/bootstrap
tests/agentbox
tests/agentbox-guest
tests/agentbox-apply
tests/agentbox-plugins
mise tasks validate --errors-only
git diff --check
```

The plugin suite uses real Neovim and a local Lazy checkout containing the
published manager revision. It defaults to Neovim's installed `lazy.nvim`;
pass another checkout as its first argument. Plugin repositories and Git
histories are temporary local fixtures. These suites do not maintain real
guests or use real credentials. `mise run verify` additionally requires the
machine's managed links, repositories, tools, plugins, and integrations to
match this checkout.

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
