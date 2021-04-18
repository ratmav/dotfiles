" os detection for vim-ctrlspace {{{
if has("win64") || has("win32") || has("win16")
    let s:vimfiles = "~/AppData/Local/nvim"
    let s:os = "windows"
else
    let s:vimfiles = "~/.config/nvim"
    if has("mac")
      let s:os = "darwin"
    else
      let s:os = "linux"
    endif
endif
" }}}

" desk {{{

" name the initial book on startup {{{
function! DeskInit()
  " TODO: the vim-ctrlspace file search complains about
  " the project root not being set if vim is opened in a directory
  " without a .git, etc. directory, i.e. if ctrlspace#roots#FindProjectRoot()
  " comes back empty. need the just set it to whatever the tcd is.
  " a 'project root not set'   " set the desk name to the last dir on path
  call DeskBookName(fnamemodify(getcwd(), ':t\'))
  echo "(•_•) ( •_•)>⌐■-■ (⌐■_■)"
endfunction
" }}}

" refresh the tree and file search cache {{{
function! DeskRefreshCache()
  call g:NERDTree.ForCurrentTab().getRoot().refresh()
  call ctrlspace#files#RefreshFiles()
endfunction
" }}}

" set the book name {{{
function! DeskBookName(name)
  call ctrlspace#tabs#SetTabLabel(tabpagenr(), a:name, 0)
  redraw!
endfunction
" }}}

" (re)bind an open book (re: move to a new working directory) {{{
function! DeskBookBind()
  call inputsave()
  let path = input("bind book to: ", "", "file")
  call inputrestore()

  " check that path exists
  if !empty(glob(path))
    " close all buffers
    silent tabdo %bd!

    " create tab and set tab current directory
    execute ":tcd " . path

    " set vim-ctrlspace project root
    call ctrlspace#roots#SetCurrentProjectRoot(path)

    " set the book name to the last dir on path
    call DeskBookName(fnamemodify(getcwd(), ':t\'))
  else
    redraw!
    echo "invalid book path"
  end
endfunction
" }}}

" start a new book {{{
function! DeskBookNew()
  call inputsave()
  let path = input("new book path: ", "", "file")
  call inputrestore()

  " check that path exists
  if !empty(glob(path))
    " create tab and set tab current directory
    tabnew
    execute ":tcd " . path

    " set vim-ctrlspace project root
    call ctrlspace#roots#SetCurrentProjectRoot(path)

    " set the desk name to the last dir on path
    call DeskBookName(fnamemodify(getcwd(), ':t\'))
  else
    redraw!
    echo "invalid book path"
  end
endfunction
" }}}

" change focus to next desk book on right {{{
function! DeskBookNext()
  tabnext
endfunction
" }}}

" change focus to previous desk book on left {{{
function! DeskBookPrevious()
  tabprevious
endfunction
" }}}

" search desk books by name {{{
function! DeskSearchBookNames()
  execute 'CtrlSpace L'
endfunction
" }}}

" search desk book pages by name {{{
function! DeskSearchBookPageNames()
  "" using pure vimscript (probably glob) for search and ignore logic
  "" like ctrlp would be nice.
  execute 'CtrlSpace O'
endfunction
" }}}

" display desk tree view {{{
function! DeskTree()
  call g:NERDTreeCreator.ToggleTabTree(".")
endfunction
" }}}

" close a desk book {{{
function! DeskBookClose()
  if tabpagenr("$") == 1
    echo "rebind the remaining book, or quit"
  else
    call ctrlspace#tabs#CloseTab()
    echo "closed " . getcwd() . " book"
  end
endfunction
" }}}

" rename a desk book {{{
function! DeskBookRename()
  call inputsave()
  let name = input("new desk name: ")
  call inputrestore()
  if name != ""
    call DeskBookName(name)
  end
endfunction
" }}}

" }}}

" plugins {{{

" plugin management (https://github.com/junegunn/vim-plug) {{{
call plug#begin('~/.local/share/nvim/plugged')
  " workflow
  Plug 'preservim/nerdtree'
  Plug 'qpkorr/vim-bufkill'
  Plug 'ratmav/marv'
  Plug 'ratmav/syfe'
  Plug 'ratmav/vim-task'
  Plug 'szw/vim-maximizer'
  Plug 'tpope/vim-fugitive'
  Plug 'vim-ctrlspace/vim-ctrlspace'

  " display
  Plug 'airblade/vim-gitgutter'
  Plug 'junegunn/rainbow_parentheses.vim'
  Plug 'morhetz/gruvbox'
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

" vim-ctrlspace {{{
set nocompatible
set hidden
set encoding=utf-8
let g:CtrlSpaceDefaultMappingKey = "<C-space> "
" }}}

" nerdtree {{{
let g:NERDTreeShowHidden=1
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
endif
" }}}

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
nnoremap <silent><C-b>h :bn<CR>
nnoremap <silent><C-b>l :bp<CR>
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

" desk {{{
nnoremap <silent><C-d>n :call DeskBookNew()<CR>
nnoremap <silent><C-d>h :call DeskBookPrevious()<CR>
nnoremap <silent><C-d>l :call DeskBookNext()<CR>
nnoremap <silent><C-d>r :call DeskBookRename()<CR>
nnoremap <silent><C-d>q :call DeskBookClose()<CR>
nnoremap <silent><C-d>c :call DeskRefreshCache()<CR>
nnoremap <silent><C-d>t :call DeskTree()<CR>
nnoremap <silent><C-d>s :call DeskSearchBookNames()<CR>
nnoremap <silent><C-d>p :call DeskSearchBookPageNames()<CR>
nnoremap <silent><C-d>b :call DeskBookBind()<CR>
" }}}

" marv {{{
nnoremap <silent><Leader>h :execute 'MarvHTML'<CR>
nnoremap <silent><Leader>p :execute 'MarvPDF'<CR>
" }}}

" syfe:
nnoremap <silent><Leader>w :execute 'SyfeWhitespaceClear'<CR>

"" vim-task:
nnoremap <silent><Leader>t :execute 'TaskDefault'<CR>

"" vv (gui):
if exists("g:vv")
  VVset fontsize=14
  " vv expects the postscript name of the font.
  VVset fontfamily="SourceCodeProforPowerline-Regular"
endif

" initialize desk on startup:
call DeskInit()
