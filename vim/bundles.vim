set nocompatible               " be iMproved
filetype off                   " required!

" Init vundle
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'SudoEdit.vim'
Bundle 'itspriddle/vim-marked'

" Programming
Bundle 'jQuery'
Bundle 'snipMate'
Bundle 'git://github.com/vim-ruby/vim-ruby.git'
Bundle 'gregsexton/MatchTag'
Bundle 'tpope/vim-cucumber'
Bundle 'matchit.zip'

" Git integration
Bundle 'git.zip'
Bundle 'fugitive.vim'
Bundle 'airblade/vim-gitgutter'

" Navigation
Bundle 'git://git.wincent.com/command-t.git'
Bundle 'The-NERD-tree'

" Indentation
Bundle 'IndentAnything'
Bundle 'Javascript-Indentation'
Bundle 'trailing-whitespace'

" Syntax
Bundle 'groenewege/vim-less'
Bundle 'tpope/vim-markdown'
Bundle 'vim-coffee-script'
Bundle 'bbommarito/vim-slim'

" Color schemes
Bundle 'Solarized'
Bundle 'Wombat'
Bundle 'wombat256.vim'

filetype plugin indent on     " required!
