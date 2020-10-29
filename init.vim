" =============== os detection
if !exists("g:os")
    if has("win64") || has("win32") || has("win16")
        let g:os = "Windows"
    else
        let g:os = "*nix"
    endif
endif

" =============== custom functions

" run a custom script for things like linting, testing, etc.
function! LocalProject()
  " set platform-specific extension
  if g:os == "*nix"
    let extension = "sh"
  elseif g:os == "windows"
    let extension = "ps1"
  endif
  let project_script = "./.local_project." . extension

  " run the script if it exists
  if filereadable(project_script)
    :execute ":! " . project_script
  else
    echo "local project script not found"
  endif
endfunction

" =============== plugin configuration

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
  Plug 'vim-airline/vim-airline-themes'
  Plug 'enricobacis/vim-airline-clock'
  Plug 'jnurmine/Zenburn'
  Plug 'plasticboy/vim-markdown'
  Plug 'jvirtanen/vim-hcl'
call plug#end()

" colorscheme
colorscheme zenburn

" rainbow_parenthesis:
autocmd BufEnter * RainbowParentheses

" vim-airline:
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = 'zenburn'

" ctrlp:
let g:ctrlp_show_hidden = 1
let g:ctrlp_max_files = 0
"  ignore tmp, swap, zip archives, and executables on macos, linux, and
"  windows
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe
"  ignore git metadata and (go, node.js) dependencies
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git)|(vendor|node_modules)$',
  \ }

" nerdtree:
"   show hidden files/folders (git metadata, dependencies)
let NERDTreeShowHidden=1

" =============== behavior

" set encoding:
set encoding=utf-8

" use the system clipboard by default:
set clipboard=unnamedplus

" no mouse:
set mouse-=a

" no backups:
set nobackup
set nowritebackup

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

" terminal
autocmd TermOpen * set bufhidden=hide

" makefile
autocmd FileType make setlocal noexpandtab
autocmd FileType make setlocal shiftwidth=8
autocmd FileType make setlocal softtabstop=8

" go
autocmd FileType go setlocal noexpandtab
autocmd FileType go setlocal shiftwidth=8
autocmd FileType go setlocal softtabstop=8

" python
autocmd FileType python setlocal foldmethod=indent

" yaml
autocmd FileType yaml setlocal indentkeys-=0#

" =============== display

syntax on

" highlight current line:
set cursorline

" highlight unwanted spaces:
autocmd BufEnter * highlight Extrawhitespace ctermbg=red guibg=red
autocmd BufEnter * match ExtraWhitespace /\s\+$/

" highlight search results:
set hlsearch

" display line numbers:
set nu

" hide line numbers in terminals:
autocmd TermOpen * setlocal nonumber norelativenumber

" always show the status line:
set laststatus=2

" clock display
let g:airline#extensions#clock#format = '%c'

" =============== key bindings

" use space as leader:
let mapleader=" "

" reload config:
nnoremap <silent><Leader>r :source $MYVIMRC <bar> :echo "config reloaded"<CR>

" write buffer:
nnoremap <silent><Leader>w :w<CR>

" remove whitespace:
nnoremap <silent><Leader>s :%s/\s\+$//e<CR>

" window management:
let g:winresizer_start_key = '<C-W>r'
nnoremap <silent><Leader>q :q<CR>

" buffer management:
nnoremap <silent><C-b>h :bp!<CR>
nnoremap <silent><C-b>l :bn!<CR>
nnoremap <silent><C-b>e :edit! <bar> :echo "buffer refreshed"<CR>
nnoremap <silent><C-b>d :BD!<CR>

" toggle nerdtree:
nnoremap <silent><Leader>n :NERDTreeToggle<CR>

" search with ctrlp:
nnoremap <silent><Leader>f :CtrlP .<CR>
nnoremap <silent><Leader>b :CtrlPBuffer<CR>
nnoremap <silent><Leader>c :CtrlPClearCache<CR>

" run local project script:
nnoremap <silent><Leader>p :call LocalProject()<CR>

" terminal:
nnoremap <silent><Leader>/ :terminal<CR>
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
