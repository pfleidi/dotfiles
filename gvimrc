set vb
" MacVim Font
set guifont=Menlo:h12

" Hide OSX Toolbar
if has("gui_running")
  set guioptions-=T
endif

colorscheme wombat

" Map Command-# to switch tabs
map  <D-0> 0gt
imap <D-0> <Esc>0gt
map  <D-1> 1gt
imap <D-1> <Esc>1gt
map  <D-2> 2gt
imap <D-2> <Esc>2gt
map  <D-3> 3gt
imap <D-3> <Esc>3gt
map  <D-4> 4gt
imap <D-4> <Esc>4gt
map  <D-5> 5gt
imap <D-5> <Esc>5gt
map  <D-6> 6gt
imap <D-6> <Esc>6gt
map  <D-7> 7gt
imap <D-7> <Esc>7gt
map  <D-8> 8gt
imap <D-8> <Esc>8gt
map  <D-9> 9gt
imap <D-9> <Esc>9gt

" Gitgutter colors
highlight clear SignColumn
highlight GitGutterAdd guifg=green guibg=#242424
highlight GitGutterChange guifg=yellow guibg=#242424
highlight GitGutterDelete guifg=red guibg=#242424
highlight GitGutterChangeDelete guifg=orange guibg=#242424


" include local gvim config
if filereadable(expand("~/.vimrc.local"))
  source ~/.gvimrc.local
endif
