" plugins {{{

" plugin management (https://github.com/junegunn/vim-plug) {{{
call plug#begin('~/.local/share/nvim/plugged')
  " workflow
  Plug 'ratmav/desk'
  Plug 'ratmav/nerdtree'
  Plug 'ratmav/vim-bufkill'
  Plug 'ratmav/marv'
  Plug 'ratmav/syfe'
  Plug 'ratmav/vim-maximizer'
  Plug 'ratmav/winresizer.vim'
  Plug 'tpope/vim-fugitive'
  Plug 'ratmav/vim-ctrlspace'

  " display
  Plug 'morhetz/gruvbox'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'airblade/vim-gitgutter'
  Plug 'ratmav/rainbow_parentheses.vim'
  Plug 'vim-airline/vim-airline'
  Plug 'ratmav/vim-airline-system'

  " misc
  Plug 'PProvost/vim-ps1' " TODO: get syntax highlighting into syfe.
  Plug 'hashivim/vim-hashicorp-tools' " TODO: get syntax highlighting into syfe.
call plug#end()
" }}}

" vim-airline {{{
let g:airline#extensions#tabline#enabled = 1
let g:airline_section_b = "%{fnamemodify(getcwd(), ':t\')} %{airline#extensions#branch#get_head()}"
let g:airline_section_x = "l(%{line('.')}/%{line('$')}) c(%{virtcol('.')})"
let g:airline_section_y = "%{&fileformat}[%{&encoding}]"
" }}}

" desk {{{
set nocompatible
set hidden
set encoding=utf-8
" }}}

" rainbow parentheses {{{
augroup rainbow_parentheses
  autocmd!

  autocmd BufEnter * RainbowParentheses
augroup END
" }}}

" }}}

" behavior {{{

" use the system clipboard by default:
set clipboard=unnamedplus

" no mouse:
set mouse-=a

" no backups:
set nobackup
set nowritebackup

" no swap:
set noswapfile

" code folding:
set foldmethod=syntax
set foldcolumn=2
set foldlevelstart=100

" autoindent width:
set expandtab
set shiftwidth=2
set softtabstop=2

" backspace should behave like other applications:
set backspace=2

" disable sql omnicomplete, which is tied to <c-c> for some reason.
let g:omni_sql_no_default_maps = 1

" }}}

" display {{{

" gui (vv) {{{
if exists("g:vv")
  VVset fontsize=14
  VVset fontfamily="SourceCodeProforPowerline-Regular"
endif
" }}}

" colors
set termguicolors
colorscheme gruvbox
syntax on

" highlight current line:
set cursorline

" highlight search results:
set hlsearch
set incsearch

" display line numbers:
set number

" always show the status line:
set laststatus=2

" embedded terminal {{{
augroup terminal_settings
  autocmd!

  autocmd TermOpen * set bufhidden=hide

  " hide line numbers in terminals:
  autocmd TermOpen * setlocal nonumber norelativenumber
augroup END
" }}}

" }}}

" bindings {{{

" use space as leader:
let mapleader=" "

" reload config:
nnoremap <silent><Leader>c :source $MYVIMRC<bar>:edit!<bar>:echo "reloaded config"<CR>

" window management:
let g:winresizer_start_key = '<Leader>r'
nnoremap <silent><C-w>z :MaximizerToggle<CR>

" buffer management {{{
nnoremap <silent><C-b>h :bn<CR>
nnoremap <silent><C-b>l :bp<CR>
nnoremap <silent><C-b>r :edit!<bar>:echo "refreshed buffer"<CR>
nnoremap <silent><C-b>q :BD!<CR>
" }}}

" embedded terminal management {{{
nnoremap <silent><C-t> :terminal<CR>
tnoremap <Esc> <C-\><C-n>
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l
" }}}

" marv {{{
nnoremap <silent><Leader>h :execute 'MarvHTML'<CR>
nnoremap <silent><Leader>p :execute 'MarvPDF'<CR>
" }}}

" syfe:
nnoremap <silent><Leader>w :execute 'SyfeWhitespaceClear'<CR>
