set nocompatible               " be iMproved
filetype off                   " required!

" Init vundle
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'SudoEdit.vim'
Bundle 'itspriddle/vim-marked'

" Snippets
Bundle "MarcWeber/vim-addon-mw-utils"
Bundle "tomtom/tlib_vim"
Bundle "garbas/vim-snipmate"
Bundle "honza/vim-snippets"

" Programming
Bundle 'vim-ruby/vim-ruby'
Bundle 'tpope/vim-rails'
Bundle 'tpope/vim-endwise'
Bundle 'tpope/vim-cucumber'
Bundle 'gregsexton/MatchTag'
Bundle 'matchit.zip'
" Bundle 'rking/ag.vim'
Bundle 'scrooloose/nerdcommenter'
Bundle 'scrooloose/syntastic'
Bundle 'kchmck/vim-coffee-script'
Bundle 'rizzatti/dash.vim'

" Git integration
Bundle 'git.zip'
Bundle 'tpope/vim-fugitive'
Bundle 'airblade/vim-gitgutter'

" Navigation
Bundle 'bling/vim-airline'
Bundle 'The-NERD-tree'
Bundle 'danro/rename.vim'
Bundle 'kien/ctrlp.vim'

" Indentation
Bundle 'IndentAnything'
Bundle 'Javascript-Indentation'
Bundle 'trailing-whitespace'

" Syntax
Bundle 'groenewege/vim-less'
Bundle 'tpope/vim-markdown'
Bundle 'haml.zip'
Bundle 'slim-template/vim-slim'

" Color schemes
Bundle 'Wombat'
Bundle 'wombat256.vim'

filetype plugin indent on     " required!

