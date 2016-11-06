" Load Pathogen runtime:
execute pathogen#infect()

syntax on

" Set encoding:
set encoding=utf-8

" No mouse:
set mouse-=a

" No unused backups:
set nobackup
set nowritebackup

" Highlight current line:
set cursorline

" Code folding:
set foldmethod=syntax
set foldcolumn=2
  " Open folds up to the number specified when opening a file:
  set foldlevelstart=100

" Highlight search results:
set hlsearch

" Autoindent width:
set expandtab
set shiftwidth=2
set softtabstop=2

" Highlight text when a line is longer than 80 columns:
autocmd BufEnter * set colorcolumn=79

" Backspace should behave like other applications:
set backspace=2

" Use space as leader:
let mapleader=" "

" Disable SQL Omnicomplete, which is tied to <C-c> for some reason.
let g:omni_sql_no_default_maps = 1

" Move tabs:
  " Move tab LEFT:
  nnoremap <Leader>h :execute "tabmove -1"<CR>
  " Move tab RIGHT:
  nnoremap <Leader>l :execute "tabmove +1"<CR>

" Display line numbers:
set nu

" Always show the status line (makes vim-airline always visible):
set laststatus=2

" Whitespace management:
  " Highlight unwanted spaces:
  autocmd BufEnter * highlight Extrawhitespace ctermbg=red guibg=red
  autocmd BufEnter * match ExtraWhitespace /\s\+$/
  " Leader command to remove whitespace:
  nnoremap <silent><Leader>w :%s/\s\+$//e<CR>

" Add blank lines and remain in Normal mode:
nnoremap <silent><Leader>o :set paste<CR>m`o<Esc>``:set nopaste<CR>

" Open file in new tab w/ tab autocompletion:
nnoremap <Leader>f :tabe<Space>

" Access Git via Fugitive:
nnoremap <Leader>g :Git<Space>

" =============== PLUGINS ===============

execute pathogen#infect()

" Solarized (Darker colorscheme for easy reading):
let g:solarized_termtrans=1
let g:solarized_visibility='low'
syntax enable
set background=dark
colorscheme solarized

" Nerdtree plugin (Browse directory tree):
let g:NERDTreeWinSize = 80
nnoremap <Leader>n :NERDTreeToggle<CR>

" Vim-airline (Populate vim-airline font glyphs from guifont):
let g:airline_powerline_fonts = 1

" Rainbow Parenthesis (Match parentheses, etc. by color):
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

" Vim-livedown (Browser-based WYSIWYG editor):
nnoremap <Leader>lp :LivedownPreview
nnoremap <Leader>lk :LivedownKill
nnoremap <Leader>lt :LivedownToggle

" =============== FILE TYPES ===============

" Makefile
autocmd FileType make setlocal noexpandtab
autocmd FileType make setlocal shiftwidth=8
autocmd FileType make setlocal softtabstop=8
