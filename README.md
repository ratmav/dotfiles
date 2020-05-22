dotfiles
========

## install

### *nix

```bash
$ git clone  https://github.com/ratmav/dotfiles.git
$ cd dotfiles && ./bootstrap.sh && source ~/.bash_profile
```

_note on macos_: the bootstrap script will install the `source code pro for powerline` fonts, however it's manually required to select a font and import the zenburn colorscheme. open terminal -> preference -> profiles and click the gear icon in the bottom left to import zenburn (`zenburn.itermcolors` in the repo). after zenburn is imported, the "default" button should be available: click the button to set zenburn as the default. use the right hand pane in the profile tab of the preferences window to set the font.

## use

### `tmux`

#### prefix

the tmux prefix is currently configured as ctrl-t.

#### pane management

* zoom
    * in: `prefix-z`
    * out: `prefix-z`
* kill: `prefix-x`
* create
    * current pane
        * vertical: `prefix-v`
        * horizontal: `prefix-s`
    * full width
        * vertical: `prefix-v`
        * horizontal: `prefix-s`
* navigate
    * left: `prefix-h`
    * right: `prefix-l`
    * up: `prefix-k`
    * down: `prefix-j`
* resize
    * left: `prefix-h`
    * right: `prefix-l`
    * up: `prefix-k`
    * down: `prefix-j`

#### vim-like yank and paste

* [tmux-yank](https://github.com/tmux-plugins/tmux-yank#key-bindings)

### `nvim`

#### leader

the neovim leader key is currently configured as space.

* leader-w clears whitespace.
* leader-h moves to the previous buffer.
* leader-l moves to the next buffer.
* leader-e refreshes the current buffer.

#### plugins

* [winresizer](https://github.com/simeji/winresizer#in-default-setting)
  * ctrl-e enters window-resize mode.
* [vim-bufkill](https://github.com/qpkorr/vim-bufkill#usage)
  * leader-d kills the buffer
* [nerdtree](https://github.com/scrooloose/nerdtree/blob/master/doc/nerdtree.txt#l220)
  * leader-n opens the tree.
* [ctrl-p](https://github.com/ctrlpvim/ctrlp.vim#basic-usage)
  * leader-f opens a file search.
  * leader-b opens a buffer search.
  * leader-c clears the cache.
* [fugitive](https://github.com/tpope/vim-fugitive/blob/master/doc/fugitive.txt#l33)
  * most of fugitive is driven by the (neo)vim command line, but the `Gstatus` commmand opens a window that has some really handy keybindings of it's own.

## update

### *nix

```bash
$ cd dotfiles
$ ./bootstrap.sh && source ~/.bash_profile
```

## initialization

run these commands after installation or updates.

### `tmux`

`prefix` + i (capital "i", for "i"nstall)

### `nvim`

on the `nvim` command line, run `:PlugInstall`.
