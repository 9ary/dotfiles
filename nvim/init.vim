" Vundle
filetype off
set rtp+=~/.nvim/bundle/Vundle.vim
call vundle#begin("~/.nvim/bundle")

Bundle "gmarik/Vundle.vim"
Bundle "bling/vim-airline"
Bundle "tpope/vim-sleuth"
Bundle "chriskempson/base16-vim"
Bundle "airblade/vim-gitgutter"
Bundle "Valloric/YouCompleteMe"
Bundle "majutsushi/tagbar"
Bundle "mitsuhiko/vim-jinja"

call vundle#end()
filetype plugin indent on

" Airline
set laststatus=2
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_left_sep = ''
let g:airline_left_alt_sep = '|'
let g:airline_right_sep = ''
let g:airline_right_alt_sep = '|'
let g:airline_symbols.whitespace = 'Ξ'
let g:airline_symbols.linenr = '¶'

" Tagbar
nmap <silent> <F8> :TagbarOpenAutoClose<CR>

" Syntax coloring
syntax enable
set background=dark
colorscheme base16-3024
hi Normal ctermbg=NONE
hi WarningMsg ctermbg=0
hi YcmErrorSign ctermbg=10 ctermfg=1

" Formatting
set encoding=utf-8
set tabstop=8
set shiftwidth=4
set expandtab
set autoindent
nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR> " Trim trailing spaces
map <C-k> :pyf /usr/share/clang/clang-format.py<cr>
nmap <C-k> m'ggvG:pyf /usr/share/clang/clang-format.py<cr>''
imap <C-k> <C-o>:pyf /usr/share/clang/clang-format.py<cr>

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
nnoremap <C-b> :buffers<CR>:buffer<Space>

" Search tweaks
set incsearch
set hlsearch
set ignorecase
set smartcase

" Paste mode
set pastetoggle=<F2>

" Undos
set undofile
set undodir=~/.nvim/undo
set undolevels=1000
set undoreload=10000

" Window switching
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Completion
set completeopt=menu,menuone,longest,preview
let g:ycm_confirm_extra_conf = 0
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_complete_in_comments = 1
let g:ycm_seed_identifiers_with_syntax = 1

" Shortcuts
nnoremap <silent> <F4> :w<CR><C-w>s :terminal make run<CR>
vnoremap <silent> // y/<C-r>"<CR>
vnoremap <C-y> "+y

" Cache
set backupdir=~/.nvim/backup
set directory=~/.nvim/backup

" Misc
set mouse=a
set nowrap
set shell=zsh
set scrolloff=5
set ruler
set backspace=2
set noesckeys
set cursorline
set lazyredraw
map ; :

" Vimpager
if exists("vimpager")
    set nonumber
    set nornu
    set laststatus=0
    set nocursorline
endif
let vimpager_disable_ansiesc = 1
let vimpager_passthrough = 0

