call plug#begin()

" Visuals
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'chriskempson/base16-vim'
Plug 'Yggdroot/indentLine'
Plug 'airblade/vim-gitgutter'

" Search
Plug 'haya14busa/is.vim'
Plug 'haya14busa/vim-asterisk'
Plug 'mileszs/ack.vim'

" Misc
Plug 'tpope/vim-sleuth'
Plug 'majutsushi/tagbar'
Plug 'chrisbra/SudoEdit.vim'
Plug 'sjl/gundo.vim'

" Language support
Plug 'mitsuhiko/vim-jinja'
Plug 'tikhomirov/vim-glsl'
Plug 'rust-lang/rust.vim'
Plug 'cespare/vim-toml'

call plug#end()

" General settings
set mouse=a
set wildmode=longest:full,full
set splitright splitbelow
set ignorecase smartcase
set undofile

" Editor look
set nowrap
set scrolloff=5
set number
set cursorline
set colorcolumn=+1
set list listchars=tab:\ \ ,trail:•,precedes:…,extends:…

" Syntax highlighting
syntax enable
set synmaxcol=1024
set background=dark
let base16colorspace=256
colorscheme base16-default-dark
hi Normal ctermbg=NONE
hi Comment ctermfg=20 cterm=italic
hi WarningMsg ctermbg=0

" Formatting rules
set encoding=utf-8
set autoindent
set tabstop=8 shiftwidth=4 expandtab
set cino=:0
au FileType text,markdown setlocal textwidth=80
au FileType python setlocal textwidth=79
" Trim trailing spaces
nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>

" Misc bindings
let mapleader=','
vnoremap <C-y> "+y
map <silent> <F2> :set invpaste<CR>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <silent> <C-t> :tabnew<CR>
nnoremap <silent> <C-n> :tabnext<CR>
nnoremap <silent> <C-p> :tabprevious<CR>
nnoremap <C-[> <C-t>
noremap ; :

" Airline
if !exists('g:airline_symbols')
    let g:airline_symbols={}
endif
let g:airline_left_sep=''
let g:airline_left_alt_sep='|'
let g:airline_right_sep=''
let g:airline_right_alt_sep='|'
let g:airline_symbols_ascii=1
let g:airline_symbols.linenr=''
let g:airline_symbols.maxlinenr=''
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#left_sep=''
let g:airline#extensions#tabline#left_alt_sep='|'
let g:airline#extensions#tabline#show_tab_nr=0
let g:airline#extensions#tabline#show_tab_type=0

" Gundo
nnoremap <F9> :GundoToggle<CR>

" Tagbar
nmap <silent> <F8> :TagbarOpenAutoClose<CR>
let g:tagbar_sort=0

" indentLine
let g:indentLine_color_term=20
let g:indentLine_char='│'
let g:indentLine_concealcursor=''
let g:indentLine_indentLevel=25
let g:indentLine_fileType=['vhdl']

" SudoEdit
let g:SudoEdit_skip_wundo=0

" ack.vim
let g:ackprg='rg -S --vimgrep'
nnoremap <Leader>a "zyiw:exe 'Ack! -Fwe ' . shellescape(@z, 1)<CR>
vnoremap <Leader>a "zy:exe 'Ack! -Fe ' . shellescape(@z, 1)<CR>

" Asterisk + is.vim
map *  <Plug>(is-nohl)<Plug>(asterisk-*)
map #  <Plug>(is-nohl)<Plug>(asterisk-#)
map g* <Plug>(is-nohl)<Plug>(asterisk-g*)
map g# <Plug>(is-nohl)<Plug>(asterisk-g#)

" YouCompleteMe
let g:ycm_confirm_extra_conf=0
let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_complete_in_comments=1
let g:ycm_seed_identifiers_with_syntax=1
let g:ycm_python_binary_path='python'
hi YcmErrorSign ctermbg=18 ctermfg=1
hi YcmWarningSign ctermbg=18 ctermfg=3
