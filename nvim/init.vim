call plug#begin("~/.nvim/bundle")

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-sleuth'
Plug 'chriskempson/base16-vim'
Plug 'airblade/vim-gitgutter'
Plug 'Valloric/YouCompleteMe'
Plug 'majutsushi/tagbar'
Plug 'mitsuhiko/vim-jinja'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tikhomirov/vim-glsl'
Plug 'Yggdroot/indentLine'
Plug 'chrisbra/SudoEdit.vim'

call plug#end()

" Airline
set laststatus=2
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_theme = 'base16'
let g:airline_left_sep = ''
let g:airline_left_alt_sep = '|'
let g:airline_right_sep = ''
let g:airline_right_alt_sep = '|'
let g:airline_symbols.whitespace = 'Ξ'
let g:airline_symbols.linenr = '¶'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#show_tab_nr = 0
let g:airline#extensions#tabline#show_tab_type = 0

" Tagbar
nmap <silent> <F8> :TagbarOpenAutoClose<CR>

" NERDTree
nmap <silent> <C-b> :NERDTreeFocus<CR>
let NERDTreeQuitOnOpen=1

" Syntax coloring
syntax enable
set background=dark
let base16colorspace=256
colorscheme base16-default
hi Normal ctermbg=NONE
hi Comment ctermfg=20
hi WarningMsg ctermbg=0
hi YcmErrorSign ctermbg=18 ctermfg=1
hi YcmWarningSign ctermbg=18 ctermfg=3

" indentLine
let g:indentLine_char = '│'

" SudoEdit.vim
let g:SudoEdit_skip_wundo=0

" Formatting
set encoding=utf-8
set tabstop=8
set shiftwidth=4
set expandtab
set autoindent
au BufRead,BufNewFile *.md setlocal textwidth=80
nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR> " Trim trailing spaces

" Line numbering
set number
set rnu
autocmd InsertEnter * :set nornu
autocmd InsertLeave * :set rnu

" Search
set incsearch
set hlsearch
set ignorecase
set smartcase

" Undos
set undofile
set undodir=~/.nvim/undo
set undolevels=1000
set undoreload=10000

" Completion
set completeopt=menu,menuone,longest,preview
let g:ycm_confirm_extra_conf = 0
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_complete_in_comments = 1
let g:ycm_seed_identifiers_with_syntax = 1

" Shortcuts
nnoremap <silent> <F4> :wa<CR><C-w>s :terminal make run<CR>
vnoremap <silent> // y/<C-r>"<CR>
vnoremap <C-y> "+y
map <silent> <F2> :set invpaste<CR>
if has("nvim")
    tnoremap <A-h> <C-\><C-n><C-w>h
    tnoremap <A-j> <C-\><C-n><C-w>j
    tnoremap <A-k> <C-\><C-n><C-w>k
    tnoremap <A-l> <C-\><C-n><C-w>l
endif
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l
nnoremap <silent> <C-t> :tabnew<CR>
nnoremap <silent> <C-n> :tabnext<CR>
nnoremap <silent> <C-p> :tabprevious<CR>
map ; :

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
set hidden
set wildmenu
set wildmode=longest:full

" Vimpager
if exists("vimpager")
    set nonumber
    set nornu
    set laststatus=0
    set nocursorline
    let g:airline#extensions#tabline#enabled = 0
endif
let vimpager_disable_ansiesc = 1
let vimpager_passthrough = 0

