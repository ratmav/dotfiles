" plugins {{{

" plugin management (https://github.com/junegunn/vim-plug) {{{
call plug#begin('~/.local/share/nvim/plugged')
  " workflow
  Plug 'ratmav/ctrlp.vim'
  Plug 'ratmav/marv'
  Plug 'ratmav/nerdtree'
  Plug 'ratmav/syfe'
  Plug 'ratmav/vim-bufkill'
  Plug 'ratmav/vim-maximizer'
  Plug 'ratmav/winresizer.vim'
  Plug 'ratmav/vim-fugitive'

  " display
  Plug 'ratmav/vim-gitgutter'
  Plug 'ratmav/gruvbox'
  Plug 'ratmav/rainbow_parentheses.vim'
  Plug 'ratmav/vim-airline-system'
  Plug 'ratmav/vim-airline'
call plug#end()
" }}}

" vim-airline {{{
let g:airline_section_b = "%{fnamemodify(getcwd(), ':t\')} %{airline#extensions#branch#get_head()}"
let g:airline_section_x = "l(%{line('.')}/%{line('$')}) c(%{virtcol('.')})"
let g:airline_section_y = "%{&fileformat}[%{&encoding}]"
" }}}

" rainbow parentheses {{{
augroup rainbow_parentheses
  autocmd!

  autocmd BufEnter * RainbowParentheses
augroup END
" }}}

" ctrl-p {{{
let g:ctrlp_show_hidden = 1
let g:ctrlp_max_files = 0
let g:ctrlp_custom_ignore = '\v\.git|node_modules'
" }}}

" nerdtree:
let g:NERDTreeShowHidden = 1

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

" window management:
let g:winresizer_start_key = '<silent><C-w>r'
nnoremap <silent><C-w>z :MaximizerToggle<CR>

" buffer management {{{
nnoremap <silent><C-b>h :bn<CR>
nnoremap <silent><C-b>l :bp<CR>
nnoremap <silent><C-b>r :edit!<bar>:echo "refreshed buffer"<CR>
nnoremap <silent><C-b>q :BD!<CR>
" }}}

" embedded terminal management {{{

" if windows.
if has('win64') || has('win32')
  nnoremap <silent><C-t> :terminal powershell -NoLogo<CR>
else
  nnoremap <silent><C-t> :terminal<CR>
end

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

" plugins (leader-driven) {{{

" use space as leader:
let mapleader=" "

" ctrl-p {{{
nnoremap <Leader>f :CtrlP .<CR>
nnoremap <Leader>b :CtrlPBuffer<CR>
nnoremap <Leader>c :CtrlPClearCache<CR>
" }}}

" reload config:
nnoremap <silent><Leader>r :source $MYVIMRC<bar>:edit!<bar>:echo "reloaded config"<CR>

" marv {{{
nnoremap <silent><Leader>h :execute 'MarvHTML'<CR>
nnoremap <silent><Leader>p :execute 'MarvPDF'<CR>
" }}}

" nerdtree:
nnoremap <silent><Leader>n :NERDTreeToggle<CR>

" syfe:
nnoremap <silent><Leader>w :execute 'SyfeWhitespaceClear'<CR>

" }}}

" }}}
