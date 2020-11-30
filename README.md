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
      * Leader-w removes (w)hitespace from a buffer
      * marv
          * Leader-p converts the current **markdown** buffer to a pdf tempfile, then opens the tempfile with the default pdf application
          * Leader-h converts the current **markdown** buffer to a html tempfile, then opens the tempfile with the default web browser
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
        * Ctrl-d-c refreshes the file tree and list (cache)
        * Ctrl-d-f (f)ile name search scoped by desk working directory
        * Ctrl-d-b (b)uffer name search scoped by desk working directory
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
  * [vim-ctrlspace](https://github.com/vim-ctrlspace/vim-ctrlspace)
      * **enables desk**: scopes buffers to tabs.
  * [nerdtree](https://github.com/preservim/nerdtree)
      * **enables desk**: directory tree view.
  * [vim-bufkill](https://github.com/qpkorr/vim-bufkill)
      * **enables desk**: leave a window or split open even when all buffers are unloaded, deleted, or wiped.
* display
  * [vim-airline](https://github.com/vim-airline/vim-airline)
      * **pairs well with desk**: buffer list, tab list, git information, etc.
      * [vim-airline-clock](https://github.com/enricobacis/vim-airline-clock)
          * strftime-formatted clock in statusline.
      * [vim-fugitive](https://github.com/tpope/vim-fugitive/blob/master/doc/fugitive.txt)
          * **enables git information in vim-airline**: git wrapper used on the vim command line.
  * [rainbow_parenthesis](https://github.com/junegunn/rainbow_parentheses.vim)
      * color-coordinated delimiters.
  * [vim-gitgutter](https://github.com/airblade/vim-gitgutter)
      * git diff in the sign column.
  * [vim-maximizer](https://github.com/szw/vim-maximizer)
      * window zoom toggle.
  * [gruvbox](https://github.com/morhetz/gruvbox)
      * colorscheme

_plus various language-specific syntax highlighting, debugging, etc. plugins depending on need._

## bad nerd poetry

```
cross platform

chairs
chairs in the air
a wild ballmer has appeared
slash back, front?
esr weeps
linus laughs
on a transatlantic flight, carmack reinvents the universe in lisp
(on an ipad)
this is my $HOME
#!/usr/bin/env bash it into sedmission
esr cheers
i am content
shellcheck disagrees
life is meaningless
```
