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

note:
  * --oni requires a full bootstrapping process.
  * a shell reload/relogin is likely required after bootstrapping.
note that --oni requires a full bootstrapping process.
```

## development

### vagrant

vagrant is used to provide clean, reusable, development environments. manage debian guests with the following commands; refer to the [vagrant cli docs](https://www.vagrantup.com/docs/cli) for more information:

```shell
$ vagrant up debian # stands up a bare debian guest.
$ vagrant ssh debian # shells into debian guest (source is mounted at /home/vagrant/dotfiles)
$ vagrant snapshot debian $SNAPSHOT_NAME # creates a snapshot of the vm.
$ vagrant debian destroy # tears down a bare debian guest.
```
