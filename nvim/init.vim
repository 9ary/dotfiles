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
Plug 'easymotion/vim-easymotion'
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'
Plug 'haya14busa/incsearch-easymotion.vim'
Plug 'rust-lang/rust.vim'
Plug 'cespare/vim-toml'

call plug#end()

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
set splitright
set splitbelow
set colorcolumn=+1
let mapleader=","

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
colorscheme base16-default-dark
hi Normal ctermbg=NONE
hi Comment ctermfg=20
hi WarningMsg ctermbg=0
hi YcmErrorSign ctermbg=18 ctermfg=1
hi YcmWarningSign ctermbg=18 ctermfg=3

" indentLine
let g:indentLine_char = '│'
let g:indentLine_concealcursor = ''

" SudoEdit.vim
let g:SudoEdit_skip_wundo=0

" EasyMotion
let g:EasyMotion_use_upper = 1
let g:EasyMotion_keys = "QWERTYUIOPASDFGHJKLZXCVBNM"
let g:EasyMotion_do_mapping = 0
map <Leader>w <Plug>(easymotion-bd-w)
map <Leader>W <Plug>(easymotion-bd-W)
map <Leader>e <Plug>(easymotion-bd-e)
map <Leader>E <Plug>(easymotion-bd-E)
map <Leader>l <Plug>(easymotion-bd-jk)

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

" Search
set incsearch
set hlsearch
set ignorecase
set smartcase

function! s:config_easyfuzzymotion(...) abort
    return extend(copy({
    \   'converters': [incsearch#config#fuzzy#converter()],
    \   'modules': [incsearch#config#easymotion#module()],
    \   'keymap': {"\<CR>": '<Over>(easymotion)'},
    \   'is_expr': 0,
    \   'is_stay': 1
    \ }), get(a:, 1, {}))
endfunction

map / <Plug>(incsearch-easymotion-/)
map ? <Plug>(incsearch-easymotion-?)
map g/ <Plug>(incsearch-stay)
noremap <silent><expr> <Leader>/ incsearch#go(<SID>config_easyfuzzymotion())
noremap <silent><expr> <Leader>? incsearch#go(<SID>config_easyfuzzymotion({'command': '?'}))
map <Leader>g/ <Plug>(incsearch-fuzzy-stay)
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)

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
let g:ycm_rust_src_path = $HOME . '/source/rust/src'
let g:ycm_python_binary_path = 'python'

" Shortcuts
nnoremap <silent> <F4> :wa<CR>:split<CR>:terminal make run<CR>
vnoremap <silent> // y/<C-r>"<CR>
vnoremap <C-y> "+y
inoremap <C-p> <ESC>"+pa
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
nnoremap <C-[> <C-t>
map ; :

" Cache
set backupdir=~/.nvim/backup
set directory=~/.nvim/backup

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

