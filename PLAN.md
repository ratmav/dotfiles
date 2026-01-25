# Complete Migration to Nix/home-manager Plan

## Overview

Migrate from Homebrew/APT/asdf to a unified Nix-based system using:
- **nix-darwin** for macOS system-level configuration (including Lulu via Homebrew cask)
- **home-manager** for cross-platform user environment (packages, dotfiles)
- **nixpkgs-unstable** channel exclusively for latest development tools
- **AWS CLI** with Python tests disabled

## Bash Style Guidelines (MUST FOLLOW)

All bash script modifications must follow these conventions:
- **Short functions**: Each does one thing
- **Locals at top**: Declare all local variables before logic
- **Namespacing**: Functions in `bash/foo.sh` prefixed with `foo_`
- **Pass shellcheck**: All code must pass shellcheck linting
- **Idempotent**: Check if tool exists first, warn if already installed (don't fail)
- **Safe operations**: Use `rm -f`, `mkdir -p` for safety
- **Output suppression**: Use `> /dev/null 2>&1` for complete silence or `quiet "command"` wrapper
- **Tool checks**: `type command > /dev/null 2>&1` pattern
- **Error handling**: Each function validates platform, calls `die` on wrong OS
- **Message format**: `msg "${OK}${FUNCNAME[0]}: action performed."`
- **Color variables**: Use OK, WARN, ERROR, CLEAR (from i.sh setup_colors)
- **Periods**: End all messages with periods

## Architecture Decisions

1. **Package Management**: All tools via Nix (home-manager)
2. **macOS Apps**: nix-darwin with homebrew module for Lulu cask
3. **Bash Config**: home-manager's `programs.bash` module (declarative)
4. **asdf**: Remove completely, use Nix + per-project flakes
5. **Neovim/WezTerm**: Same versions cross-platform via Nix unstable
6. **Platform Detection**: Single `home.nix` with conditionals

## Critical Files

### Create New:
- [x] `flake.nix` - Nix flake for command execution (replaces i.sh)
- [x] `nix/darwin-configuration.nix` - nix-darwin system config for macOS

### Replace Entirely:
- [x] `nix/home.nix` - Comprehensive home-manager config with all packages

### Simplify Heavily:
- [x] `bash/macos.sh` - Only Nix/nix-darwin/home-manager installation
- [x] `bash/kali.sh` - Only Nix/home-manager installation
- [x] `bash/posix.sh` - Only paq-nvim installation
- [x] `helpers/bash/nix.sh` - Update nix-sync command

### Keep (No Changes):
- [ ] `bash/_lib.sh` - Utility functions (msg, die, quiet, colors)
- [ ] `oo.ps1` - Windows guide (kept as reference if trapped on Windows again)

### Delete:
- [ ] `i.sh` - Replaced by flake.nix
- [ ] `nix/base.nix` - Consolidate into home.nix
- [ ] `bash/neobuild.sh` - Neovim from Nix, no source builds

### Minor Updates:
- [x] `wezterm.lua` - Remove Homebrew PATH lines (lines ~153-156)

## Implementation Steps

### Phase 0: Create Flake (replaces i.sh)

- [x] Create `flake.nix` with bootstrap and granular apps

**File**: `flake.nix`

```nix
{
  description = "Personal development environment setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-darwin" "x86_64-linux" "aarch64-darwin" "aarch64-linux" ];
    in
    {
      apps = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};

          # Wrapper that sources _lib.sh and provides bash environment
          mkApp = scriptName: script: {
            type = "app";
            program = toString (pkgs.writeShellScript scriptName ''
              set -Eeuo pipefail
              trap 'echo "error occurred"' ERR
              trap 'echo "interrupted"' SIGINT
              trap 'echo "terminated"' SIGTERM

              script_dir="${self}"

              # Source library functions
              source ${self}/bash/_lib.sh

              # Source platform scripts
              source ${self}/bash/macos.sh
              source ${self}/bash/posix.sh
              source ${self}/bash/kali.sh

              setup_colors

              ${script}
            '');
          };
        in
        {
          # Full bootstrap (auto-detects OS)
          bootstrap = mkApp "bootstrap" ''
            if [[ $(uname) == "Darwin" ]]; then
              main_macos
              main_posix
            elif _is_kali; then
              main_kali
              main_posix
            else
              die "bootstrap: unsupported platform."
            fi
          '';

          # Granular commands
          macos = mkApp "macos" ''
            if [[ $(uname) == "Darwin" ]]; then
              main_macos
            else
              die "macos: unsupported operating system."
            fi
          '';

          kali = mkApp "kali" ''
            if _is_kali; then
              main_kali
            else
              die "kali: unsupported operating system."
            fi
          '';

          posix = mkApp "posix" ''
            main_posix
          '';

          # Individual function calls for testing
          macos-nix = mkApp "macos-nix" "macos_nix";
          macos-nix-darwin = mkApp "macos-nix-darwin" "macos_nix_darwin";
          macos-darwin-config = mkApp "macos-darwin-config" "macos_darwin_config";
          macos-home-manager = mkApp "macos-home-manager" "macos_home_manager";
          macos-home-config = mkApp "macos-home-config" "macos_home_config";
          macos-shell = mkApp "macos-shell" "macos_shell";

          kali-nix = mkApp "kali-nix" "kali_nix";
          kali-nix-config = mkApp "kali-nix-config" "kali_nix_config";
          kali-home-manager = mkApp "kali-home-manager" "kali_home_manager";
          kali-home-config = mkApp "kali-home-config" "kali_home_config";

          posix-nvim-paq = mkApp "posix-nvim-paq" "posix_nvim_paq";
        });

      # Default app is bootstrap
      defaultApp = forAllSystems (system: self.apps.${system}.bootstrap);
    };
}
```

**Usage**:
- Full setup: `nix run .#bootstrap` or `nix run .`
- macOS only: `nix run .#macos`
- Kali only: `nix run .#kali`
- POSIX setup: `nix run .#posix`
- Individual functions: `nix run .#macos-nix`, `nix run .#kali-home-manager`, etc.

### Phase 1: Create nix-darwin Configuration (macOS only)

- [x] Create `nix/darwin-configuration.nix`

**File**: `nix/darwin-configuration.nix`

```nix
{ config, pkgs, ... }:

{
  # Enable nix-darwin
  services.nix-daemon.enable = true;

  # Nix configuration
  nix.settings = {
    experimental-features = "nix-command flakes";
  };

  # Use Touch ID for sudo
  security.pam.enableSudoTouchIdAuth = true;

  # System packages (macOS-specific system tools)
  environment.systemPackages = with pkgs; [
    # Minimal system tools only
  ];

  # Homebrew casks for macOS-specific GUI apps
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };
    casks = [
      "lulu"  # Objective-See firewall
    ];
  };

  # System defaults
  system.defaults = {
    dock.autohide = true;
    finder.AppleShowAllExtensions = true;
    NSGlobalDomain.AppleShowAllExtensions = true;
  };

  # Home-manager integration
  users.users.${builtins.getEnv "USER"}.home = "/Users/${builtins.getEnv "USER"}";

  # Used for backwards compatibility
  system.stateVersion = 5;
}
```

### Phase 2: Create Comprehensive home.nix

- [x] Replace `nix/home.nix` with comprehensive configuration

**File**: `nix/home.nix`

```nix
{ config, pkgs, lib, ... }:

let
  unstable = import <nixpkgs-unstable> { };

  # AWS CLI without Python tests (speeds up builds)
  awscli2-no-tests = unstable.awscli2.overrideAttrs (oldAttrs: {
    doCheck = false;
    doInstallCheck = false;
  });

  # Google Cloud SDK with GKE plugin
  gcp = unstable.google-cloud-sdk.withExtraComponents (
    with unstable.google-cloud-sdk.components; [
      gke-gcloud-auth-plugin
    ]
  );

  # Platform-specific packages
  darwinPackages = lib.optionals pkgs.stdenv.isDarwin [
    unstable.reattach-to-user-namespace
    unstable.bash-completion
  ];

  linuxPackages = lib.optionals pkgs.stdenv.isLinux [
    unstable.opensnitch  # Linux firewall
  ];

in {
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";
  home.stateVersion = "25.05";

  # Core packages (cross-platform from unstable)
  home.packages = (with unstable; [
    # Shell & Core Utils
    bash
    coreutils
    curl
    gnugrep
    gnused
    ripgrep
    shellcheck

    # Development Tools
    git
    gh
    direnv

    # Cloud Infrastructure
    azure-cli
    opentofu
    goose-cli

    # Security Tools
    cosign
    gnupg

    # Document Processing
    pandoc
    librsvg
    python3
    (texlive.combine {
      inherit (texlive) scheme-basic;
    })

    # Terminals & Editors
    wezterm

    # Package Managers
    uv

    # Browsers
    brave
  ]) ++ [ awscli2-no-tests gcp ] ++ darwinPackages ++ linuxPackages;

  # Neovim configuration
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;

    # Use external paq-nvim manager, just load our config
    extraLuaConfig = ''
      dofile(vim.fn.expand("~/Source/dotfiles/neovim.lua"))
    '';
  };

  # WezTerm configuration
  home.file.".wezterm.lua".source = ../wezterm.lua;

  # Git configuration
  programs.git = {
    enable = true;
    extraConfig = {
      core = {
        editor = "nvim";
        excludesfile = "~/.gitignore_global";
      };
      push = {
        autoSetupRemote = true;
      };
    };
  };

  # Bash configuration (replaces .bashrc)
  programs.bash = {
    enable = true;
    enableCompletion = true;

    bashrcExtra = ''
      # Environment
      export PS1="[\u@\h \W]\\$ "
      export CLICOLOR=1
      export DIRENV_LOG_FORMAT=""
      export DOCKER_CLI_HINTS=false

      # Source custom helpers
      if [ -f "$HOME/Source/dotfiles/helpers/bash/init.sh" ]; then
        source "$HOME/Source/dotfiles/helpers/bash/init.sh"
      fi

      ${lib.optionalString pkgs.stdenv.isDarwin ''
        # macOS-specific
        export HOMEBREW_NO_ANALYTICS=1
        export PATH="/Library/TeX/Root/bin/universal-darwin:$PATH"
      ''}

      # Makefile completion
      _make_completion() {
        local cur prev targets
        COMPREPLY=()
        cur="''${COMP_WORDS[COMP_CWORD]}"
        prev="''${COMP_WORDS[COMP_CWORD-1]}"
        targets=$(make -qp | awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$)/ {split($1,A,/ /);print A[1]}' | sort -u)
        COMPREPLY=( $(compgen -W "''${targets}" -- ''${cur}) )
        return 0
      }
      complete -F _make_completion make

      # Host-specific overrides
      if [ -f "$HOME/.this_machine" ]; then
        source "$HOME/.this_machine"
      fi
    '';
  };

  # direnv integration
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  # Other dotfiles
  home.file.".gitignore_global".source = ../.gitignore_global;

  programs.home-manager.enable = true;
}
```

### Phase 3: Simplify Bash Scripts

- [x] Update `bash/macos.sh`

**File**: `bash/macos.sh`

```bash
#!/usr/bin/env bash

macos_nix() {
  if [[ $(uname) == "Darwin" ]]; then
    if type nix > /dev/null 2>&1; then
      msg "${WARN}${FUNCNAME[0]}: nix already installed."
    else
      sh <(curl -L https://nixos.org/nix/install) --daemon
      msg "${OK}${FUNCNAME[0]}: installed nix."
    fi
  else
    die "${FUNCNAME[0]}: unsupported operating system."
  fi
}

macos_nix_darwin() {
  if [[ $(uname) == "Darwin" ]]; then
    if type darwin-rebuild > /dev/null 2>&1; then
      msg "${WARN}${FUNCNAME[0]}: nix-darwin already installed."
    else
      local darwin_url="https://github.com/LnL7/nix-darwin/archive/master.tar.gz"

      quiet "nix-build $darwin_url -A installer"
      ./result/bin/darwin-installer
      msg "${OK}${FUNCNAME[0]}: installed nix-darwin."
    fi
  else
    die "${FUNCNAME[0]}: unsupported operating system."
  fi
}

macos_darwin_config() {
  if [[ $(uname) == "Darwin" ]]; then
    local config_dir="$HOME/.nixpkgs"
    local dotfiles_config="$HOME/Source/dotfiles/nix/darwin-configuration.nix"

    mkdir -p "$config_dir"
    ln -sf "$dotfiles_config" "$config_dir/darwin-configuration.nix"

    msg "${OK}${FUNCNAME[0]}: linked darwin configuration."
    msg "${WARN}${FUNCNAME[0]}: run 'darwin-rebuild switch' to activate."
  else
    die "${FUNCNAME[0]}: unsupported operating system."
  fi
}

macos_home_manager() {
  if [[ $(uname) == "Darwin" ]]; then
    if type home-manager > /dev/null 2>&1; then
      msg "${WARN}${FUNCNAME[0]}: home-manager already installed."
    else
      local hm_url="https://github.com/nix-community/home-manager/archive/master.tar.gz"
      local unstable_url="https://nixos.org/channels/nixpkgs-unstable"

      nix-channel --add "$hm_url" home-manager
      nix-channel --add "$unstable_url" nixpkgs-unstable
      quiet "nix-channel --update"
      nix-shell '<home-manager>' -A install
      msg "${OK}${FUNCNAME[0]}: installed home-manager."
    fi
  else
    die "${FUNCNAME[0]}: unsupported operating system."
  fi
}

macos_home_config() {
  if [[ $(uname) == "Darwin" ]]; then
    local config_dir="$HOME/.config/home-manager"
    local dotfiles_config="$HOME/Source/dotfiles/nix/home.nix"

    mkdir -p "$config_dir"
    ln -sf "$dotfiles_config" "$config_dir/home.nix"

    msg "${OK}${FUNCNAME[0]}: linked home-manager configuration."
    msg "${WARN}${FUNCNAME[0]}: run 'home-manager switch' to activate."
  else
    die "${FUNCNAME[0]}: unsupported operating system."
  fi
}

macos_shell() {
  if [[ $(uname) == "Darwin" ]]; then
    local bash_path="$HOME/.nix-profile/bin/bash"

    if [ ! -f "$bash_path" ]; then
      msg "${WARN}${FUNCNAME[0]}: nix bash not found. run home-manager switch first."
      return
    fi

    if ! grep -qF "$bash_path" /etc/shells; then
      echo "$bash_path" | sudo tee -a /etc/shells > /dev/null
      msg "${OK}${FUNCNAME[0]}: added nix bash to /etc/shells."
    fi

    if [ "$SHELL" != "$bash_path" ]; then
      chsh -s "$bash_path"
      msg "${OK}${FUNCNAME[0]}: changed default shell to nix bash."
      msg "${WARN}${FUNCNAME[0]}: start new shell session for changes to take effect."
    fi
  else
    die "${FUNCNAME[0]}: unsupported operating system."
  fi
}

main_macos() {
  if [[ $(uname) == "Darwin" ]]; then
    macos_nix
    macos_nix_darwin
    macos_darwin_config
    macos_home_manager
    macos_home_config
    msg "${WARN}run 'darwin-rebuild switch && home-manager switch'."
    macos_shell
  fi
}
```

- [x] Update `bash/kali.sh`

**File**: `bash/kali.sh`

```bash
#!/usr/bin/env bash

kali_nix() {
  if _is_kali; then
    if type nix > /dev/null 2>&1; then
      msg "${WARN}${FUNCNAME[0]}: nix already installed."
    else
      sh <(curl -L https://nixos.org/nix/install) --daemon
      msg "${OK}${FUNCNAME[0]}: installed nix."
    fi
  else
    die "${FUNCNAME[0]}: unsupported operating system."
  fi
}

kali_nix_config() {
  if _is_kali; then
    mkdir -p ~/.config/nix
    rm -f ~/.config/nix/nix.conf
    echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
    msg "${OK}${FUNCNAME[0]}: configured nix with flakes support."
  else
    die "${FUNCNAME[0]}: unsupported operating system."
  fi
}

kali_home_manager() {
  if _is_kali; then
    if type home-manager > /dev/null 2>&1; then
      msg "${WARN}${FUNCNAME[0]}: home-manager already installed."
    else
      local hm_url="https://github.com/nix-community/home-manager/archive/master.tar.gz"
      local unstable_url="https://nixos.org/channels/nixpkgs-unstable"

      nix-channel --add "$hm_url" home-manager
      nix-channel --add "$unstable_url" nixpkgs-unstable
      quiet "nix-channel --update"
      nix-shell '<home-manager>' -A install
      msg "${OK}${FUNCNAME[0]}: installed home-manager."
    fi
  else
    die "${FUNCNAME[0]}: unsupported operating system."
  fi
}

kali_home_config() {
  if _is_kali; then
    local config_dir="$HOME/.config/home-manager"
    local dotfiles_config="$HOME/Source/dotfiles/nix/home.nix"

    mkdir -p "$config_dir"
    ln -sf "$dotfiles_config" "$config_dir/home.nix"

    msg "${OK}${FUNCNAME[0]}: linked home-manager configuration."
    msg "${WARN}${FUNCNAME[0]}: run 'home-manager switch' to activate."
  else
    die "${FUNCNAME[0]}: unsupported operating system."
  fi
}

main_kali() {
  if _is_kali; then
    kali_nix
    kali_nix_config
    kali_home_manager
    kali_home_config
    msg "${WARN}run 'home-manager switch'."
  fi
}
```

- [x] Update `bash/posix.sh`

**File**: `bash/posix.sh`

```bash
#!/usr/bin/env bash

posix_nvim_paq() {
  local paq_path="$HOME/.local/share/nvim/site/pack/paqs/start/paq-nvim"
  local paq_url="https://github.com/savq/paq-nvim"
  local plugin_init="$HOME/Source/dotfiles/neovim/plugins/init.lua"

  if [ ! -d "$paq_path" ]; then
    mkdir -p "$(dirname "$paq_path")"
    git clone --depth=1 "$paq_url" "$paq_path" > /dev/null 2>&1
    msg "${OK}${FUNCNAME[0]}: installed paq-nvim."

    # Install plugins
    timeout 30 nvim --headless \
      -c "lua dofile('$plugin_init')" \
      -c "lua require('paq').install()" \
      -c qa
    msg "${OK}${FUNCNAME[0]}: installed neovim plugins."
  else
    msg "${WARN}${FUNCNAME[0]}: paq-nvim already installed."
  fi
}

main_posix() {
  # home-manager now handles symlinks, git config, etc.
  # Only need to install paq-nvim plugin manager
  posix_nvim_paq
}
```

- [x] Update `helpers/bash/nix.sh`

**File**: `helpers/bash/nix.sh`

```bash
#!/usr/bin/env bash

nix-sync() {
  tui_info "syncing nix configuration..."
  tui_info "...updating channels"
  nix-channel --update

  if [[ $(uname) == "Darwin" ]]; then
    tui_info "...switching darwin configuration"
    darwin-rebuild switch
  fi

  tui_info "...switching home-manager generation"
  home-manager switch
}

# Keep nix-semantic as-is (still useful)
```

### Phase 4: Update WezTerm Config

- [x] Remove Homebrew PATH from `wezterm.lua`

**File**: `wezterm.lua` (lines ~153-156)

Remove these lines:
```lua
-- DELETE:
config.set_environment_variables = {
  PATH = '/opt/homebrew/bin/:' .. os.getenv('PATH')
}
```

Nix handles PATH automatically.

### Phase 5: Delete Obsolete Files

- [ ] Delete `i.sh` (replaced by flake.nix)
- [ ] Delete `nix/base.nix`
- [ ] Delete `bash/neobuild.sh`

```bash
rm i.sh
rm nix/base.nix
rm bash/neobuild.sh
```

**Note**: `oo.ps1` is intentionally kept as a reference guide in case of being trapped on Windows again.

### Phase 6: Update Documentation

- [ ] Update `NIX_MIGRATION.md`

**File**: `NIX_MIGRATION.md`

```markdown
# Nix Migration - COMPLETE

## Architecture

- **nix-darwin** (macOS): System configuration, Homebrew integration for Lulu
- **home-manager** (cross-platform): User packages, dotfiles
- **nixpkgs-unstable**: All packages for latest development tools

## Setup

### Prerequisites (All Platforms)

Before running bootstrap, enable Nix experimental features:

```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
```

### macOS
```bash
nix run .#bootstrap
darwin-rebuild switch
home-manager switch -b backup  # -b backup to safely backup existing dotfiles
```

### Kali Linux
```bash
nix run .#bootstrap
home-manager switch -b backup  # -b backup to safely backup existing dotfiles
```

### Granular Setup
```bash
# macOS only
nix run .#macos

# Kali only
nix run .#kali

# POSIX setup (paq-nvim)
nix run .#posix

# Individual functions
nix run .#macos-nix
nix run .#macos-home-manager
```

## Daily Usage

### Update everything
```bash
nix-sync
```

### Add a package
Edit `nix/home.nix`, add to `home.packages`, run `home-manager switch`

### Per-project environments
```bash
# Create flake.nix in project
echo "use flake" > .envrc
direnv allow
```

## Package Sources

- **Brave Browser**: `unstable.brave`
- **Opensnitch** (Linux): `unstable.opensnitch`
- **Lulu** (macOS): Homebrew cask via nix-darwin
- **AWS CLI**: Custom override with tests disabled
- **GCP SDK**: With GKE auth plugin

## Verification

Same tool versions across platforms:
```bash
nvim --version
wezterm --version
aws --version
```
```

## Prerequisites

Before running the bootstrap, you must enable Nix experimental features (required for flakes):

```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
```

This is a one-time setup. The bootstrap scripts also configure this, but you need it enabled to run the flake commands.

## Expected Migration Behavior

**IMPORTANT:** When running `home-manager switch` for the first time, you will encounter file conflicts. This is **normal and expected** when migrating from an existing dotfiles setup.

**Why this happens:**
- Your existing dotfiles (`.bashrc`, `.bash_profile`, `.wezterm.lua`, `.config/nvim/init.lua`) were created by the old system
- home-manager wants to manage these same files with symlinks to `/nix/store/`
- home-manager refuses to overwrite existing files by default (safety feature)

**Solution:**
Always use the `-b backup` flag on first run:
```bash
home-manager switch -b backup
```

This will:
- Rename existing files to `*.backup` (e.g., `.bashrc` → `.bashrc.backup`)
- Let home-manager create its managed symlinks
- Keep your old files safe in case you need to rollback

After verifying the new setup works, you can delete the `*.backup` files.

## Execution Order

1. - [x] **Backup**: `git checkout -b nix-migration-backup && git add -A && git commit -m "Backup"`
2. - [x] **Create flake.nix**: Command runner replacing i.sh
3. - [x] **Create darwin-configuration.nix**: New file for macOS system config
4. - [x] **Replace home.nix**: Complete rewrite with all packages
5. - [x] **Update bash scripts**: Simplify macos.sh, kali.sh, posix.sh
6. - [x] **Update helpers**: Modify nix.sh
7. - [x] **Update wezterm.lua**: Remove Homebrew PATH
8. - [ ] **Delete**: i.sh, base.nix, neobuild.sh
9. - [ ] **Test macOS**: Enable experimental features, then `nix run .#bootstrap` then `darwin-rebuild switch && home-manager switch -b backup`
10. - [x] **Test Linux**: Enable experimental features, then `nix run .#bootstrap` then `home-manager switch -b backup`
11. - [x] **Install paq-nvim**: `nix run .#posix`
12. - [x] **Verify**: Check tool versions, configs, functionality (Linux complete)

## Testing Notes (Linux/Kali)

### Status: COMPLETE ✅ (2026-01-24)

**Steps completed:**
1. [x] Enabled experimental features in `~/.config/nix/nix.conf`
2. [x] Ran `nix run .#bootstrap` successfully
3. [x] Fixed home.nix conflict: removed `.bash_profile` manual symlink (programs.bash manages it)
4. [x] Fixed home.nix conflict: removed `neovim` from home.packages (programs.neovim provides it)
5. [x] Removed old dotfile symlinks manually (`.bash_profile`, `.bashrc`, `.config/nvim/init.lua`)
6. [x] Ran `home-manager switch -b backup` successfully
7. [x] Added `setup_colors`, `msg`, `die`, `quiet` functions to `bash/_lib.sh`
8. [x] Ran `nix run .#posix` successfully
9. [x] Verified all tools from Nix in new terminal session

**Verification results:**
```
✅ nvim     → /home/ratmav/.nix-profile/bin/nvim
✅ wezterm  → /home/ratmav/.nix-profile/bin/wezterm
✅ aws      → /home/ratmav/.nix-profile/bin/aws
✅ git      → /home/ratmav/.nix-profile/bin/git
✅ gh       → /home/ratmav/.nix-profile/bin/gh
✅ direnv   → /home/ratmav/.nix-profile/bin/direnv
✅ tofu     → /home/ratmav/.nix-profile/bin/tofu (opentofu package)
✅ goose    → /home/ratmav/.nix-profile/bin/goose
✅ cosign   → /home/ratmav/.nix-profile/bin/cosign
✅ pandoc   → /home/ratmav/.nix-profile/bin/pandoc
✅ uv       → /home/ratmav/.nix-profile/bin/uv
✅ rg       → /home/ratmav/.nix-profile/bin/rg (ripgrep package)
```

**Important notes:**
- User is running **zsh**, not bash (despite bash config in home.nix)
- Must open new terminal session for PATH changes to take effect
- Some symlinks had to be removed manually (ones pointing to dotfiles repo)

### Issues Found and Fixed

1. **Experimental features requirement**: Must enable `nix-command flakes` before running flake commands (documented in Prerequisites)
2. **`.bash_profile` conflict in home.nix**: `programs.bash.enable = true` auto-manages this file, removed manual symlink
3. **Neovim duplication in home.nix**: Can't have neovim in both `home.packages` and `programs.neovim.enable = true`, removed from packages
4. **GUI apps missing libEGL.so**: Nix-installed GUI apps can't access system OpenGL libraries - **SOLVED** with nixGL wrapper
5. **WezTerm missing window decorations on Wayland**: GNOME doesn't provide server-side decorations, WezTerm uses minimal client-side decorations - **SOLVED** by forcing XWayland mode
6. **Package version conflicts after channel update**: Duplicate bash/git packages in both home.packages and programs.* - **SOLVED** by removing from home.packages

### Expected Migration Behavior

1. **Existing dotfile conflicts**: home-manager will report conflicts with existing dotfiles (`.bashrc`, `.bash_profile`, etc.). This is normal - use `-b backup` flag to safely rename them.

## Rollback Strategy

### home-manager
```bash
home-manager generations
home-manager switch --switch-generation <id>
```

### nix-darwin
```bash
darwin-rebuild --list-generations
darwin-rebuild --switch-generation <id>
```

### Git
```bash
git checkout nix-migration-backup
home-manager switch
```

## Platform Differences

### macOS
- Uses nix-darwin + home-manager
- Lulu installed via Homebrew cask (declarative)
- bash-completion from Nix

### Linux (Kali)
- home-manager only (no nix-darwin)
- Opensnitch from Nix
- No Homebrew

## Verification Checklist

- [x] Neovim loads with plugins (Linux complete)
- [x] WezTerm opens with correct config (Linux complete, uses XWayland for decorations)
- [x] Git operations work (gh, git) (Linux complete)
- [x] Cloud CLIs functional (aws, az, gcloud) (Linux complete)
- [ ] Brave browser installed
- [ ] Lulu running on macOS
- [x] Opensnitch running on Linux
- [x] direnv activates environments (Linux complete)
- [x] Pandoc generates PDFs with LaTeX (Linux complete)
- [ ] Same Neovim/WezTerm versions on both platforms (pending macOS testing)

## Known Issues & Solutions

### WezTerm Window Decorations on Wayland/GNOME

**Problem**: WezTerm shows no window borders when running in native Wayland mode on GNOME.

**Root Cause**:
- GNOME doesn't provide server-side window decorations on Wayland (by design)
- WezTerm uses smithay-client-toolkit which only provides minimal "FallbackFrame" decorations
- WezTerm doesn't integrate libdecor library for proper GNOME-themed decorations

**Solution**: Force XWayland mode (X11 compatibility layer) which provides proper decorations
- Configured in `nix/home.nix` bash function: `GDK_BACKEND=x11 QT_QPA_PLATFORM=xcb`
- Works on all GNOME/Wayland systems
- No functional differences from native Wayland for terminal emulator use case

**Tested WezTerm versions**:
- 0-unstable-2025-08-14: No Wayland decorations
- 0-unstable-2026-01-09: No Wayland decorations (latest from nixpkgs-unstable)

**Future**: Monitor [WezTerm issue #1659](https://github.com/wezterm/wezterm/issues/1659) for sctk-adwaita integration
