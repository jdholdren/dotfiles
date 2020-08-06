execute pathogen#infect()

" Ruby, rails
let $RUBYHOME=$HOME."/.rbenv/versions/2.6.2"
set rubydll=$HOME/.rbenv/versions/2.5.2/lib/libruby.2.5.2.dylib
autocmd FileType ruby,eruby set omnifunc=syntaxcomplete#Complete
autocmd FileType proto setlocal shiftwidth=2 tabstop=2
autocmd FileType coffee setlocal tabstop=4
autocmd FileType javascript setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
autocmd FileType typescript setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
autocmd FileType typescript.tsx setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
autocmd FileType html setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
autocmd FileType sh setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
autocmd FileType scss setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

" Ctrl P
set runtimepath^=~/.vim/bundle/ctrlp.vim
filetype plugin indent on
syntax on

set clipboard=unnamed
set autoindent
set backspace=indent,eol,start

set tabstop=4
set shiftwidth=4

au BufRead,BufNewFile *.md setlocal textwidth=80

" Go settings
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_extra_types = 1
let g:go_fmt_command = "goimports"

" Rust settings
let g:rustfmt_autosave = 1

noremap <Leader>y "*y
noremap <Leader>p "*p
noremap <Leader>Y "+y
noremap <Leader>P "+p

set t_Co=256
set background=dark
highlight Normal ctermbg=NONE
highlight nonText ctermbg=NONE
" the configuration options should be placed before `colorscheme forest-night`
let g:forest_night_disable_italic_comment = 1

set number
colorscheme forest-night

set runtimepath+=~/.vim/bundle/nerdtree

autocmd vimenter * if !argc() | NERDTree | endif
