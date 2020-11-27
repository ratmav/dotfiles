dotfiles
========

leverage neovim for a cross-platform, lightweight, and mnemonic editing environment

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
* `Ctrl-h` opens a new [hyper](https://github.com/vercel/hyper) tab if you need it
* run `hypertab-title` to set a tab's name

* neovim built-ins
    * Space is the neovim leader key
    * buffer management
        * Ctrl-br (r)efreshes the current buffer
        * Ctrl-bd (d)eletes the current buffer
        * use standard neovim buffer motions
        * use vim-ctrlspace (see below) to search buffers scoped by tab
    * window management
        * Ctrl-wr to (r)esize windows
        * use standard neovim window motions
    * tab managment
        * Ctrl-n opens a (n)ew tab
        * use `:tcd` to set the (t)ab (c)urrent (d)irectory, which vim-ctrlspace will use to scope buffers
        * Ctrl-h previous tab (HJKL-style movement)
        * Ctrl-l next tav (HJKL-style movement)
    * terminal management
        * Leader-t open a (terminal) in the current window as a buffer
        * use `exit`, etc. to stop shell processes (pressing any key afterwards will delete the buffer)
        * terminals are also scroped to tabs via vim-ctrlspace
* plugins and custom functions
    * Ctrl-Space opens vim-ctrl(space)
    * Leader-n toggles (n)erdtree in the current working directory, which is also managed by `:tcd`
    * Leader-r (r)eloads the nvim config
    * Leader-w removes (w)hitespace from a buffer
    * Leader-l runs a project (l)ocal shell script (for linting, testing, etc.)
    * Leader-p converts the current **markdown** buffer to a pdf tempfile, then opens the tempfile with the default pdf application
    * Leader-h converts the current **markdown** buffer to a html tempfile, then opens the tempfile with the default web browser

see `init.vim` for more information.

### plugins and extensions

* [tcd](https://github.com/neovim/neovim/blob/master/runtime/doc/editing.txt#L1263)
    * like `cd`, but sets the working directory on a per tab basis.
* [ctrl-workspace](https://github.com/vim-ctrlspace/vim-ctrlspace/blob/master/doc/ctrlspace.txt)
    * tab/buffer/file management
        * `Ctrl-Space` opens the search window
            * the buffer list (the default view) is scoped by tab, i.e. buffers are only listed in their respective tabs.
            * the tab list is opened by pressing `l`; rename a tab by pressing `m`
* [vim-fugitive](https://github.com/tpope/vim-fugitive/blob/master/doc/fugitive.txt)
    * git wrapper used on the vim command line.
* [nerdtree](https://github.com/preservim/nerdtree/blob/master/doc/NERDTree.txt)
    * feature-rich project drawer/tree view

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
