set nocompatible               " be iMproved
filetype off                   " required!

" Init vundle
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'tpope/vim-fugitive'

" Programming
Bundle 'jQuery'
Bundle 'snipMate'
Bundle 'ruby-matchit'

" Git integration
Bundle 'git.zip'
Bundle 'fugitive.vim'

" Navigation
Bundle 'git://git.wincent.com/command-t.git'
Bundle 'The-NERD-tree'

" Indentation
Bundle 'IndentAnything'
Bundle 'Javascript-Indentation'

" Syntax
Bundle 'scala.vim'
Bundle 'Markdown-syntax'

" Color schemes
Bundle 'Solarized'
Bundle 'Wombat'

filetype plugin indent on     " required!
