dotfiles
========

personal development environment on posix-compliant systems.

## init

```shell
$ mkdir ~/.ssh
$ cp ssh_key.pub ~/.ssh/ssh_key.pub
$ cp ssh_key ~/.ssh/ssh_key
$ chmod 600 ~/.ssh/ssh_key
$ eval $(ssh-agent)
$ ssh-add ~/.ssh/ssh_key
$ mkdir ~/Source && cd ~/Source
$ git clone ssh://git@github.com/ratmav/dotfiles.git
```

## use

```shell
$ cd ~/Source/dotfiles && chmod +x main.sh && ./main.sh
Usage: main.sh [--help] [--bootstrap] [--macos] [--manjaro] [--posix]

personal development environment on posix-compliant systems.

Available flags (choose one):

--help      Print this help and exit
--bootstrap run posix setup then os setup
--macos     run macos setup only
--manjaro   run manjaro setup only
--posix     run posix setup only

note that the --macos and --manjaro setups are dependent on the posix steps being run at least once.
```
