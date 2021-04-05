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
$ cd ~/Source/dotfiles && ./i.sh

                            .:
                            :.
                         :oo::.
           ..       ...:oOOOoo: ....           :
           oOOo::o::ooOOOOOoOO. .: .o::...:...::
           .:oo: :..:O8O:.  Oo   .  oOOOOOOOOOO:
          .oo8o. ....::Oo.  O8:     o8O8888O....
         .oOO8O.  ..::.:O:  :O:     :OOoo:.  .:O.
        .ooooo.    :OO: .:  :::::  .ooo:    o::..:
     .oooo:oo:.     .::::oOooOOOO:.:o.    .O8.   o:
   .:o:...    .   :::::oOOOOoooOOOOo::  .oo::   :Ooo:
  :O8O.      .o:.:oOOOoooo::o:::OOO:.oo:OOo    ::OOOOOo.
   .ooo::     .oOo:oOOoo::ooo: .:o::..ooo.     . .:OOO8OOo..
   .oO88O:o:  ooo::oo:ooo:::...:::..::::::        ..:ooo::
   .:O88OOOO:oOoOOoo:oo:oooo:.. .:..:oOOo.:..:.    ......
   .:oo:.   .:Oo:oooooooOOOOO:.  :o::ooo.:ooOO.  ..:..:o.
   .:.....:oo:OO:ooooo:oOOOOoo.   o. :o:.oo.:. .:  :o.oo
   :Oooo:oo:  :O:oOo:::::ooo:.   .o.  :oo:O:   .:..ooOOo
   :8Oo:...  ..o:oo::::.....     o:..:oOO:...:.:::ooOOOo
     :OOoo:...:o::::.:o:.     ..::.:::o::  .:.::::..o8Oo.
       :oooo..:o:.:::::o:..........:o:...::..oOo::o::O8O:..
         .oo...OO:. ...:.    .. .:oOo:.  :o: .o::::. .oo..::
           .:.:O8:..:..::..   ...::oOo.   ::.... .:.....
             .ooOo:oo:.:o::::..               oOo::.:o.
                ...... .:ooOo.              . .O8OOOO:
                          .o:                 .o:.o:.
                                               .oo:
                                                 ..

Usage: i.sh [--help] [--bootstrap] [--call]

personal development environment on posix-compliant systems.

Available flags (choose one):

--help       Print this help and exit.
--bootstrap  run os setup then generic posix setup.
--call $NAME call a specific function by name. leave name blank for a list of functions.

note:
  * a shell reload/relogin is likely required after bootstrapping.
```

## development

### vagrant

vagrant is used to provide clean, reusable, development environments. manage debian guests with the following commands; refer to the [vagrant cli docs](https://www.vagrantup.com/docs/cli) for more information:

```shell
$ vagrant up $VAGRANT_GUEST
$ vagrant ssh $VAGRANT_GUEST # source is mounted at /home/vagrant/dotfiles
$ vagrant snapshot $VAGRANT_GUEST $SNAPSHOT_NAME
$ vagrant $VAGRANT_GUEST destroy
```

#### `$VAGRANT_GUEST`

available guests:

* debian buster
* elementary os 5.1
