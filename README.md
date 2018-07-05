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

The tmux prefix is currently configured as Ctrl-Space.

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

## Resize

unbind H
bind-key -r H resize-pane -L "5"

unbind J
bind-key -r J resize-pane -D "5"

unbind K
bind-key -r K resize-pane -U "5"

unbind L
bind-key -r L resize-pane -R "5"
#### Vim-like Yank and Paste

* [tmux-yank](https://github.com/tmux-plugins/tmux-yank#key-bindings)

## `nvim`

### Leader

The Neovim leader key is currently configured as Space.

### Keybindings

* [winresizer](https://github.com/simeji/winresizer#in-default-setting)
* [vim-bufkill](https://github.com/qpkorr/vim-bufkill#usage)
* [nerdtree](https://github.com/scrooloose/nerdtree/blob/master/doc/NERDTree.txt#L220)
* [ctrl-p](https://github.com/ctrlpvim/ctrlp.vim#basic-usage)

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
