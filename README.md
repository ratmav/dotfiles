dotfiles
========

# Install

## *nix

```bash
$ git clone  https://github.com/ratmav/dotfiles.git
$ cd dotfiles && ./bootstrap.sh && source ~/.bash_profile
```

**NOTE**: Currently tested on macOS. See [#13](https://github.com/ratmav/dotfiles/issues/13) for Linux status.

# Use

## `tmux`

### Prefix

The tmux prefix is currently configured as Ctrl-T.

### Keybindings

#### Pane Management

* Zoom
    * In: `prefix-z`
    * Out: `prefix-Z`
* Kill: `prefix-x`
* Create
    * Current Pane
        * Vertical: `prefix-v`
        * Horizontal: `prefix-s`
    * Full Width
        * Vertical: `prefix-V`
        * Horizontal: `prefix-S`
* Navigate
    * Left: `prefix-h`
    * Right: `prefix-l`
    * Up: `prefix-k`
    * Down: `prefix-j`
* Resize
    * Left: `prefix-H`
    * Right: `prefix-L`
    * Up: `prefix-K`
    * Down: `prefix-J`

#### Vim-like Yank and Paste

* [tmux-yank](https://github.com/tmux-plugins/tmux-yank#key-bindings)

## `nvim`

### Leader

The Neovim leader key is currently configured as Space.

* Leader-w clears whitespace.
* Leader-h moves the the previous buffer.
* Leader-l moves the the next buffer.
* Leader-e refreshes the current buffer.
* Leader-E refreshes *all* buffers.

### Keybindings

* [winresizer](https://github.com/simeji/winresizer#in-default-setting)
* [vim-bufkill](https://github.com/qpkorr/vim-bufkill#usage)
  * Leader-d kills the buffer
* [nerdtree](https://github.com/scrooloose/nerdtree/blob/master/doc/NERDTree.txt#L220)
  * Leader-n opens the tree.
* [ctrl-p](https://github.com/ctrlpvim/ctrlp.vim#basic-usage)
  * Leader-f opens a file search.
  * Leader-b opens a buffer search.
  * Leader-c clears the cache.
* [vim-markdown-preview](https://github.com/JamshedVesuna/vim-markdown-preview)
  * Leader-m loads a markdown preview.

#### Fugitive

Most of Fugitive is driven by the (Neo)Vim command line, but the `Gstatus` commmand opens a window that has some really handy [keybindings](https://github.com/tpope/vim-fugitive/blob/master/doc/fugitive.txt#L33).

# Update

## *nix

```bash
$ cd dotfiles
$ ./bootstrap.sh && source ~/.bash_profile
```

# Initialization

Run these commands after installation or updates.

## `tmux`

`prefix` + I

**NOTE**: This means hold the Ctrl key and press Space (`prefix`), then release those keys and press Shift and the `i` key (capital "I").

## `nvim`

On the `nvim` command line, run `:PlugInstall`.
