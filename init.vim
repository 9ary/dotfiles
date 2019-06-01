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
Plug 'mbbill/undotree'

" Language support
Plug 'mitsuhiko/vim-jinja'
Plug 'tikhomirov/vim-glsl'
Plug 'rust-lang/rust.vim'
Plug 'cespare/vim-toml'

" Code completion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/echodoc.vim'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

" Local plugin
Plug '~/dotfiles/nvim'

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
set noshowmode
set signcolumn=yes

" Syntax highlighting
syntax enable
set synmaxcol=1024
set background=dark
let base16colorspace=256
colorscheme base16-default-dark
hi Normal ctermbg=NONE

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

" undotree
nnoremap <F9> :UndotreeToggle<CR>
let g:undotree_SetFocusWhenToggle=1
let g:undotree_ShortIndicators=1
let g:undotree_HighlightChangedText=0

" Tagbar
nnoremap <silent> <F8> :TagbarOpenAutoClose<CR>
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

" Deoplete
let g:deoplete#enable_at_startup=1
set completeopt=menu
call deoplete#custom#option('async_timeout', 0)
call deoplete#custom#option('auto_complete_delay', 0)
call deoplete#custom#source('_', 'matchers', ['matcher_full_fuzzy'])
call deoplete#custom#source('_', 'converters', [
    \ 'converter_remove_info',
    \ 'converter_remove_overlap',
    \ ])
inoremap <silent><expr> <Tab> pumvisible() ? '<C-n>' : '<Tab>'
inoremap <silent><expr> <S-Tab> pumvisible() ? '<C-p>' : '<S-Tab>'

" echodoc
let g:echodoc#enable_at_startup=1

" LanguageClient
function LC_maps()
    if has_key(g:LanguageClient_serverCommands, &filetype)
        nnoremap <buffer><silent> K :call LanguageClient#textDocument_hover()<CR>
        nnoremap <buffer><silent> gd :call LanguageClient#textDocument_definition()<CR>
        nnoremap <buffer><silent> <F2> :call LanguageClient#textDocument_rename()<CR>
    endif
endfunction
autocmd FileType * call LC_maps()
let g:LanguageClient_serverCommands={
    \ 'python': ['pyls'],
    \ 'rust': ['rls'],
    \ }
let g:LanguageClient_diagnosticsEnable=0
