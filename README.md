dotfiles
========

## install

### *nix

```bash
$ git clone  https://github.com/ratmav/dotfiles.git
$ cd dotfiles && ./bootstrap.sh && source ~/.bash_profile
```

_note on macos_: the bootstrap script will install the `source code pro for powerline` fonts, however it's manually required to select a font and import the zenburn colorscheme. open terminal -> preference -> profiles and click the gear icon in the bottom left to import zenburn (`zenburn.itermcolors` in the repo). after zenburn is imported, the "default" button should be available: click the button to set zenburn as the default. use the right hand pane in the profile tab of the preferences window to set the font.

## update

### *nix

```bash
$ cd dotfiles
$ ./bootstrap.sh && source ~/.bash_profile
```

## initialization

run these commands after installation or updates.

### `nvim`

on the `nvim` command line, run `:PlugInstall`.
