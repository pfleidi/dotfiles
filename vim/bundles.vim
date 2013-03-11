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
Bundle 'git://github.com/tpope/vim-markdown.git'
Bundle 'vim-coffee-script'
Bundle 'git://github.com/bbommarito/vim-slim.git'

" Color schemes
Bundle 'Solarized'
Bundle 'Wombat'
Bundle 'wombat256.vim'

filetype plugin indent on     " required!
