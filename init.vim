call plug#begin("~/.nvim/bundle")

" UI
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'chriskempson/base16-vim'
Plug 'Yggdroot/indentLine'
Plug 'airblade/vim-gitgutter'
Plug 'mhinz/vim-startify'

" Ergonomics
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/vim-asterisk'

" Programming helpers
Plug 'tpope/vim-sleuth'
Plug 'majutsushi/tagbar'

" Extra
Plug 'chrisbra/SudoEdit.vim'
Plug 'mileszs/ack.vim'
Plug 'sjl/gundo.vim'

" Language support
Plug 'mitsuhiko/vim-jinja'
Plug 'tikhomirov/vim-glsl'
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
set cursorline
set hidden
set wildmenu
set wildmode=longest:full
set splitright
set splitbelow
set colorcolumn=+1
let mapleader=","
au BufRead,BufNewFile *.h setlocal filetype=c

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
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.readonly = 'RO'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#show_tab_nr = 0
let g:airline#extensions#tabline#show_tab_type = 0

" Gundo
nnoremap <F9> :GundoToggle<CR>

" Tagbar
nmap <silent> <F8> :TagbarOpenAutoClose<CR>
let g:tagbar_sort = 0

" Syntax coloring
syntax enable
set synmaxcol=1024
set background=dark
let base16colorspace=256
colorscheme base16-default-dark
hi Normal ctermbg=NONE
hi Comment ctermfg=20 cterm=italic
hi WarningMsg ctermbg=0
hi YcmErrorSign ctermbg=18 ctermfg=1
hi YcmWarningSign ctermbg=18 ctermfg=3

" indentLine
let g:indentLine_color_term = 20
let g:indentLine_char = '│'
let g:indentLine_concealcursor = ''
let g:indentLine_indentLevel = 25
let g:indentLine_fileType = ['vhdl']

" SudoEdit.vim
let g:SudoEdit_skip_wundo=0

" ack.vim/rg
let g:ackprg = 'rg -S --vimgrep'
nnoremap <Leader>a "zyiw:exe 'Ack! -Fwe '.shellescape(@z, 1)<CR>
vnoremap <Leader>a "zy:exe 'Ack! -Fe '.shellescape(@z, 1)<CR>

" Startify
let g:startify_session_dir = $HOME . '/.nvim/sessions'
let g:startify_session_autoload = 1
let g:startify_session_persistence = 1

" Formatting
set encoding=utf-8
set tabstop=8
set shiftwidth=4
set expandtab
set autoindent
set cino=:0
au FileType text,markdown setlocal textwidth=80
au FileType python setlocal textwidth=79
nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR> " Trim trailing spaces
set list listchars=tab:\ \ ,trail:•,precedes:…,extends:…

" Line numbering
set number

" Search
set ignorecase
set smartcase
set hlsearch
let g:incsearch#auto_nohlsearch = 1
let g:incsearch#consistent_n_direction = 1
map / <Plug>(incsearch-forward)
map ? <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl)<Plug>(asterisk-*)
map #  <Plug>(incsearch-nohl)<Plug>(asterisk-g*)
map g* <Plug>(incsearch-nohl)<Plug>(asterisk-#)
map g# <Plug>(incsearch-nohl)<Plug>(asterisk-g#)

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
let g:ycm_python_binary_path = 'python'

" Shortcuts
"nnoremap <silent> <F4> :wa<CR>:split<CR>:terminal make run<CR>
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

