set nocompatible               " be iMproved
filetype off                   " required!

" Init vundle
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'SudoEdit.vim'

" Programming
Bundle 'jQuery'
Bundle 'snipMate'
Bundle 'ruby'
Bundle 'git://github.com/gregsexton/MatchTag.git'
Bundle 'git://github.com/tpope/vim-cucumber.git'
Bundle 'matchit.zip'

" Git integration
Bundle 'git.zip'
Bundle 'fugitive.vim'

" Navigation
Bundle 'git://git.wincent.com/command-t.git'
Bundle 'The-NERD-tree'

" Indentation
Bundle 'IndentAnything'
Bundle 'Javascript-Indentation'
Bundle 'trailing-whitespace'

" Syntax
Bundle 'scala.vim'
Bundle 'Markdown-syntax'
Bundle 'vim-coffee-script'

" Color schemes
Bundle 'Solarized'
Bundle 'Wombat'
Bundle 'wombat256.vim'

filetype plugin indent on     " required!
