" =============== os detection

" TODO: simple plugin...with tests and linting?
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

" =============== custom functions

" TODO: simple plugin...with tests and linting?
" run a custom script for things like linting, testing, etc.
function! LocalProject()
  " set platform-specific extension
  if s:os == "windows"
    let extension = "ps1"
  else
    let extension = "sh"
  endif
  let project_script = "./.local_project." . extension

  " run the script if it exists
  if filereadable(project_script)
    :execute ":! " . project_script
  else
    echo "local project script not found"
  endif
endfunction

" TODO: simple plugin...with tests and linting?
" convert markdown to pdf or html
function! MarkdownConverter(extension)
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
          :execute ":! rm -f " . targetfile
        endif
        :execute prefix . " " . targetfile . " " . sourcefile

        " open the tempfile
        if s:os == "darwin"
          :execute ":! open " . targetfile
        elseif s:os == "linux"
          :execute ":! xdg-open " . targetfile
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
  Plug 'preservim/nerdtree'
  Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug 'vim-airline/vim-airline'
  Plug 'qpkorr/vim-bufkill'
  Plug 'simeji/winresizer'
  Plug 'airblade/vim-gitgutter'
  Plug 'PProvost/vim-ps1'
  Plug 'enricobacis/vim-airline-clock'
  Plug 'morhetz/gruvbox'
  Plug 'plasticboy/vim-markdown'
  Plug 'jvirtanen/vim-hcl'
  Plug 'vim-ctrlspace/vim-ctrlspace'
call plug#end()

" rainbow_parenthesis:
autocmd BufEnter * RainbowParentheses

" vim-airline:
let g:airline#extensions#tabline#enabled = 1

" nerdtree:
let g:NERDTreeShowHidden=1

" vim-ctrlspace:
set nocompatible
set hidden
set encoding=utf-8
if executable("ag")
  let g:CtrlSpaceGlobCommand = 'ag -l --nocolor -g ""'
endif

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

" use space as leader:
let mapleader=" "

" builtins (windows, buffers, tabs, terminals)

"" window management:
let g:winresizer_start_key = '<C-W>r'

"" buffer management:
nnoremap <silent><C-b>r :edit!<bar>:echo "refreshed buffer"<CR>
nnoremap <silent><C-b>d :BD!<CR>

"" tab managment:
nnoremap <silent><C-t>n :tabnew<bar>:echo "new tab created"<CR>
nnoremap <silent><C-t>h :tabprevious<CR>
nnoremap <silent><C-t>l :tabnext<CR>

"" terminal management:
nnoremap <silent><Leader>t :terminal<CR>
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

" addons (plugins, shortcuts, custom functions)

"" vim-ctrlspace:
let g:CtrlSpaceDefaultMappingKey = "<C-space> "

"" nerdtree:
nnoremap <silent><Leader>n :NERDTreeToggle .<CR>

"" reload config:
nnoremap <silent><Leader>r :source $MYVIMRC<bar>:echo "reloaded config"<CR>

"" remove whitespace:
nnoremap <silent><Leader>w :%s/\s\+$//e<CR>

"" run local project script:
nnoremap <silent><Leader>l :call LocalProject()<CR>

"" convert markdown to pdf:
nnoremap <silent><Leader>p :call MarkdownConverter(".pdf")<CR>

"" convert markdown to html:
nnoremap <silent><Leader>h :call MarkdownConverter(".html")<CR>
