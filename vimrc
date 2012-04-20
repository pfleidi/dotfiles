" pfleidis vimrc file

" Use Vim settings, rather then Vi settings (much better!).
set nocompatible

" Vundle and bundles configuration
source ~/.vim/bundles.vim

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" allow backspacing over everything in insert mode
set backspace=indent,eol,start
set history=120             " keep 120 lines of command line history
set autoindent              " auto indenting
set smartindent             " smart indenting
set ruler                   " show the cursor position all the time
set showcmd                 " display incomplete commands
set incsearch               " do incremental searching
set smartcase               " do smart case matching
set background=dark         " dark background is used
set laststatus=2            " show always status line on bottom
set ttyfast                 " we have a fast tty
set showmatch               " Show matching brackets.
set matchtime=5             " Bracket blinking.


" auto-change directory
if exists('+autochdir')
  set autochdir
else
  autocmd BufEnter * silent! lcd %:p:h:gs/ /\\ /
endif

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

" vim also supports a mouse
set mouse=a

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

" Use Ack instead of Grep when available
if executable("ack")
  set grepprg=ack\ -H\ --nogroup\ --nocolor\ --ignore-dir=tmp\ --ignore-dir=coverage
endif

" Tab completion options
" (only complete to the longest unambiguous match, and show a menu)
set completeopt=longest,menu
set wildmode=list:longest,list:full
set complete=.,t

" Remove highlight after search
nmap <silent> ,/ :nohlsearch<CR>

autocmd FileType xml,xsd,xslt,xhtml,html,php,aspvbs inoremap <buffer> <M-&> &amp;
autocmd FileType xml,xsd,xslt,xhtml,html,php,aspvbs inoremap <buffer> <M-<> &lt;
autocmd FileType xml,xsd,xslt,xhtml,html,php,aspvbs inoremap <buffer> <M->> &gt;
autocmd FileType xml,xsd,xslt,xhtml,html,php,aspvbs inoremap <buffer> <M-'> &apos;
autocmd FileType xml,xsd,xslt,xhtml,html,php,aspvbs inoremap <buffer> <M-"> &quot;

" Always show statusline
set laststatus=2
set noruler

" Color scheme settings
colorscheme wombat256mod

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

" CTags
map <Leader>rt :!ctags --extra=+f -R *<CR><CR>
map <C-\> :tnext<CR>

" Show buffer number, filetype, fileformat and fileencoding in statusline
set statusline=[%n]\ [%f]\ %w%y%r%m[%{&fileformat}][%{&fileencoding}]\ %=\ %l/%L,%-5c\ %P\

"improve autocomplete menu color
highlight Pmenu ctermbg=238 gui=bold

" Include local vim config
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif
