" =============== os detection

" os detection.
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


" =============== desk functions

"" name the first desk on startup
function! DeskInit()
  " set the desk name to the last dir on path
  call DeskName(fnamemodify(getcwd(), ':t\'))
endfunction

"" refresh the tree and file search cache
function! DeskCache()
  call g:NERDTree.ForCurrentTab().getRoot().refresh()
  call ctrlspace#files#RefreshFiles()
endfunction

"" set the desk name
function! DeskName(name)
  call ctrlspace#tabs#SetTabLabel(tabpagenr(), a:name, 0)
  redraw!
endfunction

"" move an existing desk to a new working directory
function! DeskMove()
  "" DeskNew() is probabaly a good starting point
  "" close all buffers and windows in desk as well for a clean slate).
  echo "TODO: move an existing desk to a new working directory"
endfunction

"" start a new desk
function! DeskNew()
  call inputsave()
  let path = input("New desk path: ", "", "file")
  call inputrestore()

  " check that path exists
  if !empty(glob(path))
    " create tab and set tab current directory
    tabnew
    execute ":tcd " . path

    " set vim-ctrlspace project root
    call ctrlspace#roots#SetCurrentProjectRoot(path)

    " set the desk name to the last dir on path
    call DeskName(fnamemodify(getcwd(), ':t\'))
  else
    redraw!
    echo "invalid desk path"
  end
endfunction

"" change focus to next desk on right
function! DeskNext()
  tabnext
endfunction

"" change focus to previous desk on left
function! DeskPrevious()
  tabprevious
endfunction

"" search buffers open in desk
function! DeskSearchBuffers()
  "" should be able to mimic vim-ctrlspace's logic here.
  call CtrlSpace O
endfunction

"" search files in desk path
function! DeskSearchFiles()
  "" using pure vimscript (probably glob) for search and ignore logic
  "" like ctrlp would be nice.
  call CtrlSpace H
endfunction

function! DeskTree()
  call g:NERDTreeCreator.ToggleTabTree(".")
endfunction

"" close a desk
function! DeskQuit()
  if tabpagenr("$") == 1
    echo "move, don't quit, the last desk"
  else
    call ctrlspace#tabs#CloseTab()
    echo "closed " . getcwd() . " desk"
  end
endfunction

"" rename a desk
function! DeskRename()
  call inputsave()
  let name = input("New desk name: ")
  call inputrestore()
  if name != ""
    call DeskName(name)
  end
endfunction

" run a local desk script for things like linting, testing, etc.
function! DeskProject()
  " set platform-specific extension
  if s:os == "windows"
    let extension = "ps1"
  else
    let extension = "sh"
  endif
  let project_script = "./.desk." . extension

  " run the script if it exists
  if filereadable(project_script)
    execute ":! " . project_script
  else
    echo "local project script not found"
  endif
endfunction

" =============== marv

" markdown html and pdf previews
function! Marv(extension)
  " is pandoc installed?
  if executable("pandoc")
    " is the extension supported?
    if a:extension == ".pdf" || a:extension == ".html"
      "is the buffer in markdown?
      if expand("%:e") != "md"
        echo "buffer is not a markdown file"
      else
        let sourcefile = expand("%:t")
        let title = fnamemodify(sourcefile, ":r")
        let targetfile = "/tmp/" . title . a:extension

        " only set the title metadata attribute for html
        if a:extension == ".pdf"
          let prefix = ':! pandoc -s -V geometry:margin=1in -o'
        else
          let prefix = ':! pandoc --metadata title="' . title . '" -s -V geometry:margin=1in -o'
        endif

        " clean up old tempfiles, then build new tempfile
        if s:os == "windows"
          echo "windows support not implemented yet."
        else
          execute ":! rm -f " . targetfile
        endif
        execute prefix . " " . targetfile . " " . sourcefile

        " open the tempfile
        if s:os == "darwin"
          execute ":! open " . targetfile
        elseif s:os == "linux"
          execute ":! xdg-open " . targetfile
        elseif s:os == "windows"
          echo "windows support not implemented yet."
        endif
      endif
    else
      echo "only conversion to pdf or html is supported."
    endif
  else
    echo "pandoc is not installed"
  endif
endfunction

" =============== plugins

call plug#begin('~/.local/share/nvim/plugged')
  Plug 'tpope/vim-fugitive'
  Plug 'junegunn/rainbow_parentheses.vim'
  Plug 'vim-airline/vim-airline'
  Plug 'qpkorr/vim-bufkill'
  Plug 'airblade/vim-gitgutter'
  Plug 'PProvost/vim-ps1'
  Plug 'enricobacis/vim-airline-clock'
  Plug 'morhetz/gruvbox'
  Plug 'plasticboy/vim-markdown'
  Plug 'jvirtanen/vim-hcl'
  Plug 'vim-ctrlspace/vim-ctrlspace'
  Plug 'sebdah/vim-delve'
  Plug 'preservim/nerdtree'
  Plug 'szw/vim-maximizer'
  Plug 'ctrlpvim/ctrlp.vim'
call plug#end()

" rainbow_parenthesis:
autocmd BufEnter * RainbowParentheses

" vim-airline:
let g:airline#extensions#tabline#enabled = 1

" vim-ctrlspace:
set nocompatible
set hidden
set encoding=utf-8
let g:CtrlSpaceDefaultMappingKey = "<C-space> "

" nerdtree:
let g:NERDTreeShowHidden=1

" =============== behavior

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

" terminal
autocmd TermOpen * set bufhidden=hide

" filetypes

"" makefile
autocmd FileType make setlocal noexpandtab
autocmd FileType make setlocal shiftwidth=8
autocmd FileType make setlocal softtabstop=8

"" go
autocmd FileType go setlocal noexpandtab
autocmd FileType go setlocal shiftwidth=8
autocmd FileType go setlocal softtabstop=8

"" python
autocmd FileType python setlocal foldmethod=indent

"" yaml
autocmd FileType yaml setlocal indentkeys-=0#

" =============== display

set termguicolors
colorscheme gruvbox

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

" current working directory display:
let g:airline_section_b = "%{fnamemodify(getcwd(), ':t\')} %{airline#extensions#branch#get_head()}"

" clock display
let g:airline#extensions#clock#format = '%a %b %e %l:%M %p'

" =============== key bindings

""" window management:
nnoremap <silent><C-w>z :MaximizerToggle<CR>

""" buffer management:
nnoremap <silent><C-b>r :edit!<bar>:echo "refreshed buffer"<CR>
nnoremap <silent><C-b>q :BD!<CR>

"" terminal management:
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

"" desk

nnoremap <silent><C-d>n :call DeskNew()<CR>
nnoremap <silent><C-d>h :call DeskPrevious()<CR>
nnoremap <silent><C-d>l :call DeskNext()<CR>
nnoremap <silent><C-d>r :call DeskRename()<CR>
nnoremap <silent><C-d>q :call DeskQuit()<CR>
nnoremap <silent><C-d>c :call DeskCache()<CR>
nnoremap <silent><C-d>m :call DeskMove()<CR>
nnoremap <silent><C-d>t :call DeskTree()<CR>
"" TODO: nnoremap <silent><C-d>f :call DeskSearchFiles()<CR>
nnoremap <silent><C-d>f :CtrlSpace O<CR>
"" TODO: nnoremap <silent><C-d>b :call DeskSearchBuffers()<CR>
nnoremap <silent><C-d>b :CtrlSpace H<CR>
nnoremap <silent><C-d>p :call DeskProject()<CR>

"" leader shortcuts:

""" use space as leader:
let mapleader=" "

"" reload config:
nnoremap <silent><Leader>r :source $MYVIMRC<bar>:echo "reloaded config"<CR>

"" remove whitespace:
nnoremap <silent><Leader>w :%s/\s\+$//e<CR>

"" convert markdown to pdf:
nnoremap <silent><Leader>p :call Marv(".pdf")<CR>

"" convert markdown to html:
noremap <silent><Leader>h :call Marv(".html")<CR>

"" initialize desk on startup:
call DeskInit()
