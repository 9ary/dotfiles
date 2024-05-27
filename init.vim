call plug#begin()

" Visuals
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'jan-warchol/selenized', { 'rtp': 'editors/vim' }
Plug 'lukas-reineke/indent-blankline.nvim'
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
Plug 'ojroques/nvim-osc52'

" Language support
" Partially included with (n)vim, but missing indentation rules
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

" Local plugin
Plug '~/dotfiles/nvim'

call plug#end()

" General settings
set mouse=a
set wildmode=longest:full,full
set splitright splitbelow
set ignorecase smartcase
set undofile
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'

if expand('$UID') == 0
    set nobackup
    set noswapfile
    set noundofile
endif

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
set cino=:0(su0Wsm1
au FileType text,markdown setlocal textwidth=80
au FileType python setlocal textwidth=79
" Trim trailing spaces
nnoremap <F5> <cmd>let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>

" Misc bindings
let mapleader=','
set whichwrap=""
noremap <S-Space> <Left>
nnoremap <Leader>w <C-w>p
nnoremap <C-t> <cmd>tabnew<CR>
nnoremap <C-Tab> <cmd>tabnext<CR>
nnoremap <C-S-Tab> <cmd>tabprevious<CR>
noremap ; :

" OSC52
lua << EOF
osc52 = require'osc52'.setup {
    max_length = 0,
    silent = false,
    trim = false,
}

vim.keymap.set('n', '<leader>c', require'osc52'.copy_operator, {expr = true})
vim.keymap.set('n', '<leader>cc', '<leader>c_', {remap = true})
vim.keymap.set('v', '<leader>c', require'osc52'.copy_visual)
EOF

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

" indent-blankline.nvim
exe 'hi IblIndent guifg='.g:terminal_color_8.' guibg=NONE guisp=NONE gui=NONE ctermfg=8 ctermbg=None cterm=NONE'
exe 'hi IblScope guifg='.g:terminal_color_7.' guibg=NONE guisp=NONE gui=NONE ctermfg=7 ctermbg=None cterm=NONE'
lua << EOF
local char = "▎"
require("ibl").setup {
    indent = {
        char = char,
        tab_char = char,
    },
    scope = {
        show_start = false,
        show_end = false,
    },
}
EOF

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
  ensure_installed = {
      "c",
      "lua",
      "vim",
      "vimdoc",
      "query",
      "rust",
  },
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
"inoremap <silent><expr> <Tab> pumvisible() ? '<C-n>' : '<Tab>'
"inoremap <silent><expr> <S-Tab> pumvisible() ? '<C-p>' : '<S-Tab>'
