" plugins {{{

" plugin management (https://github.com/junegunn/vim-plug) {{{
call plug#begin('~/.local/share/nvim/plugged')
  " workflow
  Plug 'qpkorr/vim-bufkill'
  Plug 'ratmav/marv'
  Plug 'ratmav/syfe'
  Plug 'ratmav/vim-task'
  Plug 'szw/vim-maximizer'
  Plug 'tpope/vim-fugitive'
  Plug 'sebdah/vim-delve'
  Plug 'preservim/nerdtree'
  Plug 'ctrlpvim/ctrlp.vim'

  " display
  Plug 'airblade/vim-gitgutter'
  Plug 'junegunn/rainbow_parentheses.vim'
  Plug 'morhetz/gruvbox'
  Plug 'vim-airline/vim-airline'
  Plug 'ratmav/vim-airline-system'
  Plug 'PProvost/vim-ps1'
  Plug 'cespare/vim-toml'
  Plug 'jvirtanen/vim-hcl'
  Plug 'hashivim/vim-hashicorp-tools'
call plug#end()
" }}}

" vim-airline {{{
let g:airline#extensions#tabline#enabled = 1
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

" nerdtree:
let g:NERDTreeShowHidden=1

" ctrlp {{{
let g:ctrlp_show_hidden = 1
let g:ctrlp_max_files = 0
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git)|(vendor|node_modules)$',
  \ }
" }}}

" }}}

" functions {{{

function! GonvimWorkspaceBind()
  call inputsave()
  let path = input("bind workspace to: ", "", "file")
  call inputrestore()

  " check that path exists
  if !empty(glob(path))
    " close all buffers
    silent %bd!

    " create tab and set tab current directory
    execute ":cd " . path

    " set the book name to the last dir on path
    execute 'NERDTreeCWD'
  else
    redraw!
    echo "invalid path"
  end
endfunction

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

set termguicolors
colorscheme gruvbox

syntax on

" highlight current line:
set cursorline

" highlight search results:
set hlsearch
set incsearch

" display line numbers:
set number relativenumber

" always show the status line:
set laststatus=2

" terminal_display {{{
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
nnoremap <silent><Leader>r :source $MYVIMRC<bar>:edit!<bar>:echo "reloaded config"<CR>

" window management:
nnoremap <silent><C-w>z :MaximizerToggle<CR>

" buffer management {{{
nnoremap <silent><C-b>r :edit!<bar>:echo "refreshed buffer"<CR>
nnoremap <silent><C-b>q :BD!<CR>
" }}}

" terminal management {{{
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

" ctrlp {{{
nnoremap <silent><Leader>f :CtrlP .<CR>
nnoremap <silent><Leader>b :CtrlPBuffer<CR>
nnoremap <silent><Leader>c :CtrlPClearCache<CR>
" }}}

" nerdtree:
nnoremap <silent><Leader>n :execute 'NERDTreeToggle'<CR>

" syfe:
nnoremap <silent><Leader>w :execute 'SyfeWhitespaceClear'<CR>

"" vim-task:
nnoremap <silent><Leader>t :execute 'TaskDefault'<CR>

" }}}
