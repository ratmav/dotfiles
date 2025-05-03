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
    * *nix: use your package manager.
    * windows: use [git for windows](https://gitforwindows.org), which provides bash emulation via `msys`. powershell should be installed by default.
* system shell (live off the land)
    * *nix: [bash](https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html)
    * windows: [powershell](https://docs.microsoft.com/en-us/powershell/)

## keyboard shortcuts

### neovim shortcuts

#### universal escape key: Ctrl-]

a universal escape key (`Ctrl-]`) has been implemented to provide consistent behavior across all buffer types in Neovim 0.11+. this addresses the change where terminal buffers now require a different command to exit insert mode.

- **standard buffers**:  exits insert mode (equivalent to `Esc`)
- **terminal buffers**:  exits insert mode (equivalent to `Ctrl-\ Ctrl-n`)
- **command-line mode**: exits command-line mode (equivalent to `Ctrl-c`)
- **telescope windows**: closes telescope floating windows in a single keystroke

this key combination maintains the left pinky, right pinky pattern while providing consistent behavior regardless of buffer context.

#### leader-based commands (space key)

- `<Leader>r`:  reload Neovim configuration
- `<Leader>n`:  toggle NERDTree file explorer
- `<Leader>f`:  find files (Telescope)
- `<Leader>b`:  find buffers (Telescope)
- `<Leader>g`:  find git files (Telescope)
- `<Leader>l`:  live grep search (Telescope)
- `<Leader>d`:  open git diff view (Diffview)

#### buffer management (Ctrl-b prefix)

- `<C-b>h/l`:   navigate buffers (left/right)
- `<C-b>r`:     refresh current buffer
- `<C-b>q`:     close buffer (Vim-Bufkill)

#### window management (Ctrl-w prefix)

- `<C-w>h/j/k/l`: navigate windows (left/down/up/right)
- `<C-w>r`:     start window resize mode (WinResizer)
- `<C-w>z`:     toggle maximize current window (Vim-Maximizer)

#### terminal management

- `<C-t>`:      open terminal
- `<C-]>`:      exit terminal mode (universal escape)

### wezterm shortcuts

#### terminal emulator commands (Ctrl-e leader)

- `<C-e>n`:     new WezTerm tab
- `<C-e>h/l`:   navigate tabs (left/right)
- `<C-e>c`:     activate copy mode (similar to vi-style visual mode)
- `<C-e>y`:     copy/yank text
- `<C-e>p`:     paste text
