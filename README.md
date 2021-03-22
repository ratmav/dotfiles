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
$ cd ~/Source/dotfiles && ./main.sh
Usage: main.sh [--help] [--bootstrap] [--oni]

personal development environment on posix-compliant systems.

Available flags (choose one):

--help      Print this help and exit
--bootstrap run os setup then generic posix setup
--oni       builds the oni editor from source

note that --oni requires a full bootstrapping process.
```

## vagrant

vagrant is used as convenience to develop in clean environments, with a makefile provided as a command wrapper. to use:

```shell
$ make debian_up # stands up a bare debian guest.
$ make debian_ssh # ssh's to the debian guest for interactive use.
$ make debian_destroy # tears down a bare debian guest.
```

**note**: vagrant _does not_ provision guests; ssh into the guest and run `cd dotfiles && ./main.sh --bootstrap`, etc. to run various tasks.
