dotfiles
========

```
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
```

## *nix: `$ cd ./dotfiles && ./i.sh`

```
Usage: i.sh [--help] [--bootstrap] [--call]

personal development environment on posix-like platforms.

Available flags (choose one):

--help       Print this help and exit.
--bootstrap  run os setup then generic posix setup.
--call $NAME call a specific function by name. leave name blank for a list of functions.

note:
  * a shell reload/relogin is likely required after bootstrapping.
```

## windows: `Set-Location .\dotfiles; .\oo.ps1`

```
Usage: oo.ps1 [help] [bootstrap] [call]

personal development environment on windows platforms.

Available flags (choose one):

help       Print this help and exit.
bootstrap  run os setup then generic posix setup.
call $NAME call a specific function by name. leave name blank for a list of
functions.
```

## dependencies

* [wezterm](https://wezfurlong.org/wezterm/index.html) (terminal emulator)
* [neovim](https://neovim.io/) (text editor)
* [git](https://git-scm.com/book/en/v2) (version control)
* [bash](https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html) on *nix; [powershell](https://docs.microsoft.com/en-us/powershell/) on windows.

### *nix

git and bash are probably already installed on *nix. use your package manager otherwise.

### windows

use [git for windows](https://gitforwindows.org), which provides bash emulation via `msys`.  should be installed by default.

## shell hopping

### windows

* from powershell:
    * `bash` usually launches the bash binary that ships with wsl 2 that is installed as part of the docker desktop installation.
    * `'C:\Program Files\Git\bin\bash.exe'` is the standard location of the git bash binary if git for windows is installed. it is probably useful to alias this to something like `git-bash` in the powershell profile: `Set-Alias -Name git-bash -Value "C:\Program Files\Git\bin\bash.exe"`
* from git bash: `powershell` launches...powershell.
