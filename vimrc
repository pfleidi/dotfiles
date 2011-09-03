" pfleidis vimrc file
"
" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start
set history=120            " keep 120 lines of command line history
set autoindent             " auto indenting
set smartindent            " smart indenting
set ruler                  " show the cursor position all the time
set showcmd                " display incomplete commands
set incsearch              " do incremental searching
set smartcase              " do smart case matching
set background=dark        " dark background is used
set laststatus=2           " show always status line on bottom
set ttyfast                " we have a fast tty

" auto-change directory 
"if exists('+autochdir')
"  set autochdir
"else
"  autocmd BufEnter * silent! lcd %:p:h:gs/ /\\ /
"endif

" set backup dir
set backup
set backupdir=~/.vim/backup/
set directory=~/.vim/tmp

" No Tabs are used
set tabstop=2
set shiftwidth=2
set expandtab 
set smarttab
set number

" Don't use Ex mode, use Q for formatting
map Q gq
" vim supports also a mouse
" set mouse=i

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
    au!

    " For all text files set 'textwidth' to 78 characters.
    autocmd FileType text setlocal textwidth=78

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    autocmd BufReadPost *
          \ if line("'\"") > 0 && line("'\"") <= line("$") |
          \   exe "normal! g`\"" |
          \ endif
  augroup END
else
  set autoindent     " always set autoindenting on
endif " has("autocmd")

" Keys
set pastetoggle=<F8>
nmap <F9> :set invnumber<CR>

" Remove highlight after search
nmap <silent> ,/ :nohlsearch<CR>

set fdm=expr
set fde=getline(v:lnum)=~'^\\s*#'?1:getline(prevnonblank(v:lnum))=~'^\\s*#'?1:getline(nextnonblank(v:lnum))=~'^\\s*#'?1:0

autocmd FileType xml,xsd,xslt,xhtml,html,php,aspvbs inoremap <buffer> <M-&> &amp;
autocmd FileType xml,xsd,xslt,xhtml,html,php,aspvbs inoremap <buffer> <M-<> &lt;
autocmd FileType xml,xsd,xslt,xhtml,html,php,aspvbs inoremap <buffer> <M->> &gt;
autocmd FileType xml,xsd,xslt,xhtml,html,php,aspvbs inoremap <buffer> <M-'> &apos;
autocmd FileType xml,xsd,xslt,xhtml,html,php,aspvbs inoremap <buffer> <M-"> &quot;

" Always show statusline
set laststatus=2
set noruler
colorscheme wombat

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" NERDTree config
let NERDTreeChDirMode=2
let NERDTreeIgnore=['\.vim$', '\~$', '\.pyc$', '\.swp$']
let NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$',  '\~$']
let NERDTreeShowBookmarks=0
map <F3> :NERDTreeToggle<CR>


" Show buffer number, filetype, fileformat and fileencoding in statusline
set statusline=[%n]\ [%f]\ %w%y%r%m[%{&fileformat}][%{&fileencoding}]\ %=\ %l/%L,%-5c\ %P\ 
