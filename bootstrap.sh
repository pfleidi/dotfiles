#!/bin/sh

for file in $HOME/dotfiles/*; do
  filename=$(basename $file)
  destination=$HOME/.$filename
  if [ $filename == $(basename $0) -o $filename == "README.md" ]; then continue ; fi

  if [ -e $destination ]; then
    if [ -L $destination ]; then
      printf "$destination is already a link!\n"
    else
      printf "$destination already exists. Remove it!\n"
    fi
  else
    printf "Linking $file to $destination\n"
    ln -s $file $destination
  fi
done

# set up zsh shell environment
if [ -d $HOME/.oh-my-zsh ]; then
  printf "OH-MY-ZSH is already installed, only updating ...\n"
  zsh $HOME/.oh-my-zsh/tools/upgrade.sh
else
  printf "Installing OH-MY-ZSH\n"
  git clone git://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh
  chsh -s /bin/zsh
fi

if [ -d $HOME/.rvm ]; then
  printf "RVM is already installed\n"
else
  printf "Installing RVM\n"
  curl -s https://rvm.beginrescueend.com/install/rvm | sh
fi

