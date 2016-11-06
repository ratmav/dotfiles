dotfiles
========

personal configuration and documentation collection project for general purpose use.

# Use

## Install

```bash
$ git clone --recursive https://github.com/ratmav/dotfiles.git
$ cp ~/.bash_profile ~/.local_bash_profile # To save system-specific configs.
$ cd dotfiles && ./bootstrap.sh && source ~/.bash_profile
```

## Update

```bash
$ cd dotfiles
$ git pull --recurse-submodules
$ ./bootstrap.sh && source ~/.bash_profile
```
