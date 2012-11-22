#!/bin/bash

dir=$(dirname $0)
dotdir=$($dir/bin/realpath $dir)

for file in $dotdir/*; do
  filename=$(basename $file)
  dotfile=$HOME/.$filename
  if [ $filename = $(basename $0) -o $filename = "README.md" ]; then continue ; fi

  if [ -e $dotfile ]; then
    if [ -L $dotfile ]; then
      printf "$dotfile is already a link!\n"
    else
      printf "$dotfile already exists. Remove it!\n"
    fi
  else
    printf "Linking $dotfile to $file\n"
    ln -s $file $dotfile
  fi
done

# set up zsh shell environment
if [ -d $HOME/.oh-my-zsh ]; then
  printf "OH-MY-ZSH is already installed, only updating ...\n"
  zsh $HOME/.oh-my-zsh/tools/upgrade.sh
else
  printf "Installing OH-MY-ZSH\n"
  git clone git://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh
fi

# Installing/updating rbenv
if [ -d $HOME/.rbenv ]; then
  printf "Updading rbenv ...\n"
  cd $HOME/.rbenv; git pull; cd -
else
  git clone git://github.com/sstephenson/rbenv.git $HOME/.rbenv
fi

# Install vim bundles
if [ -d $HOME/.vim/bundle/vundle ]; then
  printf "Updading vundle ...\n"
  cd $HOME/.vim/bundle/vundle; git pull; cd -
else
  git clone http://github.com/gmarik/vundle.git $HOME/.vim/bundle/vundle
fi

vim -u ~/.vim/bundles.vim +BundleInstall +q +q
