" Vundle
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Bundle "gmarik/Vundle.vim"
Bundle "altercation/vim-colors-solarized"
Bundle "bling/vim-bufferline"
Bundle "bling/vim-airline"

call vundle#end()
filetype plugin indent on

" Airline
set laststatus=2
let g:airline_powerline_fonts=1

" Solarized and syntax coloring
syntax enable
set background=dark
let g:solarized_termtrans=1
colorscheme solarized

" Formatting
set encoding=utf-8
set tabstop=4
set shiftwidth=4
set autoindent
nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR> " Trim trailing spaces

" Line numbering
set number
set rnu
autocmd InsertEnter * :set nornu
autocmd InsertLeave * :set rnu
function! NumberToggle()
    if(&rnu == 1)
        set nornu
    else
        set rnu
    endif
endfunc
nnoremap <silent> <C-n> :call NumberToggle()<CR>

" Buffer switching
nnoremap <C-b> :buffer<Space>
let g:bufferline_echo = 0
let g:bufferline_rotate = 1


" Search tweaks
set incsearch
set hlsearch

" Paste mode
set pastetoggle=<F2>

" Window switching
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Cache
set backupdir=~/.vim/backup
set directory=~/.vim/backup

" Misc
set mouse=a
set nowrap
set shell=zsh
set scrolloff=5
set ruler
set ttyfast
set noesckeys
map ; :

