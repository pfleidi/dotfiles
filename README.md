# My dotfiles

This repo contains [@pfleidi's](http://github.com/pfleidi) dotfiles for:

- zsh
- (Mac)vim
- GNU screen
- tmux
- Ruby/irb

Under dotfiles/bin there are some useful scripts and tools.

## Usage

```bash
git clone https://github.com/pfleidi/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap.sh
```

## OSX Setup

```bash
# Install commandline tools
xcode-select --install

# Install homebrew
ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"

# Install packages
cd ~/dotfiles && brew bundle
```

## Installed frameworks

- [OH-MY-ZSH](https://github.com/robbyrussell/oh-my-zsh)
- [rbenv](https://github.com/sstephenson/rbenv)
- [vundle](https://github.com/gmarik/vundle)
- [Homebrew](http://brew.sh/) (optional)

## Custom PATHs

The dotfiles bundle doesn't contain any custom PATH settings exept for the helpers contained under dotfiles/bin. If you wish to add custom PATHs, put them into ~/.profile.

## Local Overrides

Local ZSH settings can be overridden by creating a ~/.zshrc.local file:

```bash
# Override theme
export ZSH_THEME="candy"
# Override plugins
plugins=(dirpersist git npm deb debian rvm gem)
```
