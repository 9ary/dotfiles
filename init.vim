call plug#begin()

" Visuals
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'jan-warchol/selenized', { 'rtp': 'editors/vim' }
Plug 'Yggdroot/indentLine'
Plug 'airblade/vim-gitgutter'

" Search
Plug 'ggandor/leap.nvim'
Plug 'haya14busa/is.vim'
Plug 'haya14busa/vim-asterisk'
Plug 'mileszs/ack.vim'

" Misc
Plug 'tpope/vim-sleuth'
Plug 'majutsushi/tagbar'
Plug 'mbbill/undotree'
Plug 'ojroques/vim-oscyank'

" Language support
Plug 'mitsuhiko/vim-jinja'
Plug 'tikhomirov/vim-glsl'
Plug 'rust-lang/rust.vim'
Plug 'cespare/vim-toml'
Plug 'LnL7/vim-nix'

" nvim extensions
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Code completion
Plug 'neovim/nvim-lspconfig'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'deoplete-plugins/deoplete-lsp', { 'do': ':UpdateRemotePlugins' }

call plug#end()

" General settings
set mouse=a
set wildmode=longest:full,full
set splitright splitbelow
set ignorecase smartcase
set undofile
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'

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
set termguicolors
set background=light
colorscheme selenized_bw
" hi Normal ctermbg=NONE

" Formatting rules
set encoding=utf-8
set autoindent
set tabstop=8 shiftwidth=4 expandtab
set cino=:0
au FileType text,markdown setlocal textwidth=80
au FileType python setlocal textwidth=79
" Trim trailing spaces
nnoremap <F5> <cmd>let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>

" Misc bindings
let mapleader=','
vnoremap <C-y> "+y
noremap <M-m> h
noremap <M-n> j
noremap <M-e> k
noremap <M-i> l
nnoremap <C-m> <C-w>h
nnoremap <C-n> <C-w>j
nnoremap <C-e> <C-w>k
nnoremap <C-i> <C-w>l
nnoremap <C-t> <cmd>tabnew<CR>
nnoremap <C-Tab> <cmd>tabnext<CR>
nnoremap <C-S-Tab> <cmd>tabprevious<CR>
noremap ; :

" Custom clipboard provider
let g:clipboard={
    \ 'name': 'termclip',
    \ 'copy': {
    \     '+': {lines, regtype -> OSCYankString(join(lines, "\n"))},
    \     '*': {lines, regtype -> OSCYankString(join(lines, "\n"))},
    \     },
    \ 'paste': {
    \     '+': 'wl-paste -n',
    \     '*': 'wl-paste -pn',
    \     },
    \ 'cache_enabled': 0,
    \ }

" Airline
if !exists('g:airline_symbols')
    let g:airline_symbols={}
endif
let g:airline_left_sep=''
let g:airline_left_alt_sep='|'
let g:airline_right_sep=''
let g:airline_right_alt_sep='|'
let g:airline_symbols_ascii=1
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#left_sep=''
let g:airline#extensions#tabline#left_alt_sep='|'
let g:airline#extensions#tabline#show_tab_nr=0
let g:airline#extensions#tabline#show_tab_type=0

" undotree
nnoremap <F9> <cmd>UndotreeToggle<CR>
let g:undotree_SetFocusWhenToggle=1
let g:undotree_ShortIndicators=1
let g:undotree_HighlightChangedText=0

" Tagbar
nnoremap <F8> <cmd>TagbarOpenAutoClose<CR>
let g:tagbar_sort=0

" indentLine
let g:indentLine_color_term=20
let g:indentLine_char='│'
let g:indentLine_concealcursor=''
let g:indentLine_indentLevel=25
let g:indentLine_fileType=['vhdl']

" ack.vim
let g:ackprg='rg -S --vimgrep'
nnoremap <Leader>a "zyiw:exe 'Ack! -Fwe ' . shellescape(@z, 1)<CR>
vnoremap <Leader>a "zy:exe 'Ack! -Fe ' . shellescape(@z, 1)<CR>

" leap.nvim
lua require('leap').add_default_mappings()

" Asterisk + is.vim
map *  <Plug>(is-nohl)<Plug>(asterisk-*)
map #  <Plug>(is-nohl)<Plug>(asterisk-#)
map g* <Plug>(is-nohl)<Plug>(asterisk-g*)
map g# <Plug>(is-nohl)<Plug>(asterisk-g#)
map z*  <Plug>(is-nohl)<Plug>(asterisk-z*)
map gz* <Plug>(is-nohl)<Plug>(asterisk-gz*)
map z#  <Plug>(is-nohl)<Plug>(asterisk-z#)
map gz# <Plug>(is-nohl)<Plug>(asterisk-gz#)
let g:asterisk#keeppos = 1

" tree-sitter
lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "rust" },
  highlight = {
    enable = true,
  },
}
EOF

" Telescope
nnoremap <Leader>f <cmd>Telescope find_files<CR>
nnoremap <Leader>g <cmd>Telescope live_grep<CR>
lua << EOF
require'telescope'.setup {
  defaults = {
    borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
  }
}
EOF

" LSP
lua << EOF
require'lspconfig'.pylsp.setup {}
require'lspconfig'.rust_analyzer.setup {}
vim.lsp.handlers["textDocument/publishDiagnostics"] = nil
EOF

" Deoplete
let g:deoplete#enable_at_startup=1
set completeopt=menu
call deoplete#custom#source('_', 'matchers', ['matcher_full_fuzzy'])
inoremap <silent><expr> <Tab> pumvisible() ? '<C-n>' : '<Tab>'
inoremap <silent><expr> <S-Tab> pumvisible() ? '<C-p>' : '<S-Tab>'
