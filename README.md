dotfiles
========

## install

### *nix

```bash
$ git clone  https://github.com/ratmav/dotfiles.git
$ cd dotfiles && ./bootstrap.sh && source ~/.bash_profile
```

## update

### *nix

```bash
$ cd dotfiles
$ ./bootstrap.sh && source ~/.bash_profile
```

## initialization

on the `nvim` command line, run `:PlugInstall`.

## use

see `init.vim` for custom keybindings.

### plugins and extensions

* [tcd](https://github.com/neovim/neovim/blob/master/runtime/doc/editing.txt#L1263)
    * like `cd`, but sets the working directory on a per tab basis.
* [ctrl-workspace](https://github.com/vim-ctrlspace/vim-ctrlspace/blob/master/doc/ctrlspace.txt)
    * tab/buffer/file management
        * `Ctrl-Space` opens the search window
            * buffer search (the default view) is scoped by tab, i.e. buffers are only listed in their respective tabs.
* [vim-fugitive](https://github.com/tpope/vim-fugitive/blob/master/doc/fugitive.txt)
    * git wrapper used on the vim command line.
* [nerdtree](https://github.com/preservim/nerdtree/blob/master/doc/NERDTree.txt)
    * feature-rich project drawer/tree view
