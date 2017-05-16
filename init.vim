" =============== PLUGINS

call plug#begin('~/.local/share/nvim/plugged')
  Plug 'chriskempson/base16-vim'
  Plug 'tpope/vim-fugitive'
  Plug 'vim-airline/vim-airline'
  Plug 'junegunn/rainbow_parentheses.vim'
  Plug 'scrooloose/nerdtree'
  Plug 'roman/golden-ratio'
  Plug 'mbbill/undotree'
  Plug 'majutsushi/tagbar'
  Plug 'kien/ctrlp.vim'
call plug#end()

" vim-airline:
let g:airline_powerline_fonts = 1

" rainbow_parenthesis:
autocmd BufEnter * RainbowParentheses

" undotree:
if has("persistent_undo")
  set undodir=~/.undodir/
  set undofile
endif

" =============== BEHAVIOR

" Set encoding:
set encoding=utf-8

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

" Makefile
autocmd FileType make setlocal noexpandtab
autocmd FileType make setlocal shiftwidth=8
autocmd FileType make setlocal softtabstop=8

" Python
autocmd FileType python setlocal foldmethod=indent

" =============== DISPLAY

syntax on

colorscheme base16-solarized-dark

" Highlight current line:
set cursorline

" Mark the 80th column.
autocmd BufEnter * set colorcolumn=79

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

" Move tab LEFT:
nnoremap <Leader>h :tabmove -1<CR>

" Move tab RIGHT:
nnoremap <Leader>l :tabmove +1<CR>

" Toggle NERDTree:
nnoremap <Leader>n :NERDTreeToggle<CR>

" Terminal:
nnoremap <Leader>t :terminal<CR>
tnoremap <Esc> <C-\><C-n>

" Toggle Undotree:
nnoremap <Leader>u :UndotreeToggle<CR>

" Toggle Tagbar:
nnoremap <Leader>c :TagbarToggle<CR>

" Fuzzy file search with CtrlP:
nnoremap <Leader>f :CtrlP<CR>
