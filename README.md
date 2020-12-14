dotfiles
========

leverage [neovim](https://github.com/neovim/neovim) and [hyper](https://github.com/vercel/hyper) for a cross-platform, lightweight, and mnemonic editing environment

## install

### *nix

```bash
$ chmod +x bootstrap.sh && ./bootstrap.sh && source ~/.bash_profile
```

## update

### *nix

```bash
$ ./bootstrap.sh && source ~/.bash_profile
```

## initialization

on the `nvim` command line, run `:PlugInstall`.

## use

### mnemonic keybindings

* hyper
    * `Ctrl-h` opens a new hyper tab if you need it (remote host?)
    * run `hypertab-title` to set a tab's name

* neovim
    * Space is the neovim leader key
      * Leader-r (r)eloads the nvim config
        * syfe
            * Leader-w removes (w)hitespace from a buffer
        * marv
            * Leader-h renders markdown and opens a html preview
            * Leader-p renders markdown and opens a pdf preview
    * buffer management
        * Ctrl-b-r (r)efreshes the current buffer
        * Ctrl-b-q (q)uits the current buffer
        * use standard vi buffer motions
    * window management
        * Ctrl-w-z to (z)oom in and out of windows
        * use standard vi window motions
    * terminal management
        * Ctrl-t open a (t)erminal in the current window as a buffer
        * use `exit`, etc. to stop shell processes (pressing any key afterwards will delete the buffer)
        * terminals are also scroped to tabs via vim-ctrlspace
    * desk
        * Ctrl-d-n creates a (n)ew desk
        * Ctrl-d-l moves right to the next desk, hjk(l)-style
        * Ctrl-d-h moves left to the previous desk, (h)jkl-style
        * Ctrl-d-c refreshes the (c)ache of file names in the current desk.
        * Ctrl-d-f (f)ile name search scoped by desk working directory
        * Ctrl-d-d (d)esk name search
        * Ctrl-d-t opens a (t)ree view of the desk working directory
        * Ctrl-d-r (r)enames the current desk
        * Ctrl-d-m (m)oves an existing desk
        * Ctrl-d-p runs a (p)roject shell script, if present in the current working directory
            * `.desk.sh` on *nix
            * `.desk.ps1` on windows
        * Ctrl-d-q (q)uits the current desk

see `init.vim` for more information.

### plugins

#### hyper

* [hyperterm-bold-tab](https://github.com/dawsbot/hyperterm-bold-tab)
    * highlight the currently active tab.
* [hyper-gruv](https://github.com/Tallestthomas/hyper-gruv)
    * colorscheme

#### vim

* workflow
  * [preservim/nerdtree](https://github.com/preservim/nerdtree)
      * **enables desk**: directory tree view.
  * [qpkorr/vim-bufkill](https://github.com/qpkorr/vim-bufkill)
      * **enables desk**: leave a window or split open even when all buffers are unloaded, deleted, or wiped.
  * [ratmav/marv](https://github.com/ratmav/marv)
      * html and pdf markdown previews.
  * [ratmav/syfe](https://github.com/ratmav/syfe)
      * syntax highlighting and folding for various languages; whitespace management.
  * [szw/vim-maximizer](https://github.com/szw/vim-maximizer)
      * window zoom toggle.
  * [vim-fugitive](https://github.com/tpope/vim-fugitive/blob/master/doc/fugitive.txt)
      * **enables git information in vim-airline**: git wrapper used on the vim command line.
  * [vim-ctrlspace/vim-ctrlspace](https://github.com/vim-ctrlspace/vim-ctrlspace)
      * **enables desk**: scopes buffers to tabs; file and buffer name search.

* display
  * [airblade/vim-gitgutter](https://github.com/airblade/vim-gitgutter)
      * git diff in the sign column.
  * [junegunn/rainbow_parenthesis](https://github.com/junegunn/rainbow_parentheses.vim)
      * color-coordinated delimiters.
  * [morehetz/gruvbox](https://github.com/morhetz/gruvbox)
      * colorscheme
  * [vim-airline/vim-airline](https://github.com/vim-airline/vim-airline)
      * **pairs well with desk**: buffer list, tab list, git information, etc.

_plus various plugins depending on need._
