" =============== PLUGINS

call plug#begin('~/.local/share/nvim/plugged')
  Plug 'tpope/vim-fugitive'
  Plug 'junegunn/rainbow_parentheses.vim'
  Plug 'scrooloose/nerdtree'
  Plug 'vim-airline/vim-airline'
  Plug 'qpkorr/vim-bufkill'
  Plug 'simeji/winresizer'
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'airblade/vim-gitgutter'
  Plug 'PProvost/vim-ps1'
  Plug 'jnurmine/Zenburn'
  Plug 'vim-airline/vim-airline-themes'
call plug#end()

" colorscheme
set background=dark
colors zenburn

" rainbow_parenthesis:
autocmd BufEnter * RainbowParentheses

" vim-airline:
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = 'zenburn'

" ctrlp:
let g:ctrlp_show_hidden = 1
let g:ctrlp_max_files=0
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" nerdtree:
let NERDTreeShowHidden=1

" =============== BEHAVIOR

" Set encoding:
set encoding=utf-8

" Use the system clipboard by default:
set clipboard=unnamedplus

" No mouse:
set mouse-=a

" No backups:
set nobackup
set nowritebackup

" Code folding:
set foldmethod=syntax
set foldcolumn=2
set foldlevelstart=100

" Autoindent width:
set expandtab
set shiftwidth=2
set softtabstop=2

" Backspace should behave like other applications:
set backspace=2

" Disable SQL Omnicomplete, which is tied to <C-c> for some reason.
let g:omni_sql_no_default_maps = 1

" Terminal
autocmd TermOpen * set bufhidden=hide

" Makefile
autocmd FileType make setlocal noexpandtab
autocmd FileType make setlocal shiftwidth=8
autocmd FileType make setlocal softtabstop=8

" Python
autocmd FileType python setlocal foldmethod=indent

" YAML
autocmd FileType yaml setlocal indentkeys-=0#

" =============== DISPLAY

syntax on

" Highlight current line:
set cursorline

" Highlight unwanted spaces:
autocmd BufEnter * highlight Extrawhitespace ctermbg=red guibg=red
autocmd BufEnter * match ExtraWhitespace /\s\+$/

" Highlight search results:
set hlsearch

" Display line numbers:
set nu

" Always show the status line:
set laststatus=2

" =============== KEY BINDINGS

" Use space as leader:
let mapleader=" "

" Remove whitespace:
nnoremap <silent><Leader>w :%s/\s\+$//e<CR>

" Buffer management:
nnoremap <Leader>h :bp!<CR>
nnoremap <Leader>l :bn!<CR>
nnoremap <Leader>d :BD!<CR>
nnoremap <Leader>e :edit!<CR>
nnoremap <Leader>E :checkt <CR>

" Toggle NERDTree:
nnoremap <Leader>n :NERDTreeToggle<CR>

" Search with CtrlP:
nnoremap <Leader>f :CtrlP .<CR>
nnoremap <Leader>b :CtrlPBuffer<CR>
nnoremap <Leader>c :CtrlPClearCache<CR>

" Terminal:
:tnoremap <Esc> <C-\><C-n>
:tnoremap <A-h> <C-\><C-N><C-w>h
:tnoremap <A-j> <C-\><C-N><C-w>j
:tnoremap <A-k> <C-\><C-N><C-w>k
:tnoremap <A-l> <C-\><C-N><C-w>l
:inoremap <A-h> <C-\><C-N><C-w>h
:inoremap <A-j> <C-\><C-N><C-w>j
:inoremap <A-k> <C-\><C-N><C-w>k
:inoremap <A-l> <C-\><C-N><C-w>l
:nnoremap <A-h> <C-w>h
:nnoremap <A-j> <C-w>j
:nnoremap <A-k> <C-w>k
:nnoremap <A-l> <C-w>l
