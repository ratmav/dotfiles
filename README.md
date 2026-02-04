dotfiles
========

```
                            .:
                            :.
                         :oo::.
           ..       ...:oooooo: ....           :
           oooo::o::oooooooooo. .: .o::...:...::
           .:oo: :..:o8o:.  oo   .  ooooooooooo:
          .oo8o. ....::oo.  o8:     o8o8888o....
         .ooo8o.  ..::.:o:  :o:     :oooo:.  .:o.
        .ooooo.    :oo: .:  :::::  .ooo:    o::..:
     .oooo:oo:.     .::::oooooooo:.:o.    .o8.   o:
   .:o:...    .   :::::ooooooooooooo::  .oo::   :ooo:
  :o8o.      .o:.:oooooooo::o:::ooo:.oo:ooo    ::oooooo.
   .ooo::     .ooo:ooooo::ooo: .:o::..ooo.     . .:ooo8ooo..
   .oo88o:o:  ooo::oo:ooo:::...:::..::::::        ..:ooo::
   .:o88oooo:ooooooo:oo:oooo:.. .:..:oooo.:..:.    ......
   .:oo:.   .:oo:oooooooooooo:.  :o::ooo.:oooo.  ..:..:o.
   .:.....:oo:oo:ooooo:ooooooo.   o. :o:.oo.:. .:  :o.oo
   :oooo:oo:  :o:ooo:::::ooo:.   .o.  :oo:o:   .:..ooooo
   :8oo:...  ..o:oo::::.....     o:..:ooo:...:.:::oooooo
     :oooo:...:o::::.:o:.     ..::.:::o::  .:.::::..o8oo.
       :oooo..:o:.:::::o:..........:o:...::..ooo::o::o8o:..
         .oo...oo:. ...:.    .. .:ooo:.  :o: .o::::. .oo..::
           .:.:o8:..:..::..   ...::ooo.   ::.... .:.....
             .oooo:oo:.:o::::..               ooo::.:o.
                ...... .:oooo.              . .o8oooo:
                          .o:                 .o:.o:.
                                               .oo:
                                                 ..
```

## what is ish?

**ish** is a bash utility library and convention-driven task runner.

**this repository contains:**
- **ish** - bash utility library (terminal ui, platform detection, common operations) and task runner
- **configuration** - dotfiles for neovim, wezterm, bash, git
- **bootstrap scripts** - set up development environments on macos and linux

**core utilities:**
- `bash/tui.sh` - terminal ui (colors, prompts, messages)
- `bash/platform.sh` - platform detection (os, architecture)
- `bash/utils.sh` - common operations (existence checks, file operations)

**task modules:**
- `bash/bootstrap/` - system setup and configuration
- `bash/git/` - git operations and cleanup utilities
- `bash/nix.sh` - nix package version management
- `bash/self/` - testing and linting

**design principles:**
- convention over configuration (no yaml, no config files)
- live off the land (minimal dependencies: bash + ssh + posix utilities)
- self-contained and portable
- idempotent operations (safe to run multiple times)

see `docs/philosophy.md` for design principles and `docs/vision.md` for strategic direction.

## quick start

```bash
# bootstrap a fresh system
./ish bootstrap macos all    # macos
./ish bootstrap kali all      # kali linux
./ish bootstrap posix all     # generic posix

# run specific operations
./ish git clean prune         # prune local branches missing on remote
./ish platform os             # detect operating system
./ish tui info "message"      # colored terminal output

# get help at any level
./ish help
./ish bootstrap help
./ish git help
```

## command structure

commands follow left-to-right scope narrowing:

```bash
ish                              # top level
ish bootstrap                    # bootstrap operations
ish bootstrap macos              # macos-specific bootstrap
ish bootstrap macos homebrew     # homebrew operations
ish bootstrap macos homebrew install  # install homebrew
```

functions map to cli commands via naming convention:
```bash
bootstrap_macos_homebrew_install()  →  ish bootstrap macos homebrew install
```

see `docs/conventions.md` for complete details.

## dependencies

* [wezterm](https://wezfurlong.org/wezterm/index.html) (terminal emulator)
* [neovim](https://neovim.io/) (text editor)
* [git](https://git-scm.com/book/en/v2) (version control)
* [nix](https://nixos.org) (project environment manager)
* [direnv](https://direnv.net) (automatic environment switching)
    * *nix: use your package manager.
    * windows: use [git for windows](https://gitforwindows.org), which provides bash emulation via `msys`. powershell should be installed by default.
* system shell (live off the land)
    * *nix: [bash](https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html)
    * windows: [powershell](https://docs.microsoft.com/en-us/powershell/)

## keyboard shortcuts

### neovim shortcuts

#### universal escape key: ctrl-]

a universal escape key (`ctrl-]`) has been implemented to provide consistent behavior across all buffer types in neovim 0.11+. this addresses the change where terminal buffers now require a different command to exit insert mode.

- **standard buffers**:  exits insert mode (equivalent to `esc`)
- **terminal buffers**:  exits insert mode (equivalent to `ctrl-\ ctrl-n`)
- **command-line mode**: exits command-line mode (equivalent to `ctrl-c`)
- **telescope windows**: closes telescope floating windows in a single keystroke

this key combination maintains the left pinky, right pinky pattern while providing consistent behavior regardless of buffer context.

#### leader-based commands (space key)

- `<leader>r`:  reload neovim configuration
- `<leader>n`:  toggle nerdtree file explorer
- `<leader>f`:  find files (telescope)
- `<leader>b`:  find buffers (telescope)
- `<leader>g`:  find git files (telescope)
- `<leader>l`:  live grep search (telescope)
- `<leader>d`:  open git diff view (diffview)
- `<leader>t`:  toggle scratchpad (trap)
- `<leader>m`:  toggle markdown preview (marv)

#### buffer management (ctrl-b prefix)

- `<c-b>h/l`:   navigate buffers (left/right)
- `<c-b>r`:     refresh current buffer
- `<c-b>q`:     close buffer (vim-bufkill)

#### window management (ctrl-w prefix)

- `<c-w>h/j/k/l`: navigate windows (left/down/up/right)
- `<c-w>r`:     start window resize mode (winresizer)
- `<c-w>z`:     toggle maximize current window (vim-maximizer)

#### terminal management

- `<c-t>`:      open terminal
- `<c-]>`:      exit terminal mode (universal escape)

### wezterm shortcuts

#### terminal emulator commands (ctrl-e leader)

- `<c-e>n`:     new wezterm tab
- `<c-e>h/l`:   navigate tabs (left/right)
- `<c-e>c`:     activate copy mode (similar to vi-style visual mode)
- `<c-e>y`:     copy/yank text
- `<c-e>p`:     paste text
