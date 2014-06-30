" Pathogen
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

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
set expandtab
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
nnoremap <C-n> :call NumberToggle()<cr>

" Search tweaks
set incsearch
set hlsearch

" Cache
set backupdir=~/.vim/backup
set directory=~/.vim/backup

" Misc
set nowrap
set shell=zsh
set scrolloff=5
set ruler
set ttyfast

