# Nix Migration Plan

This repo is transitioning from Homebrew + asdf to Nix on macOS while maintaining productivity during the migration.

## Current Setup

- **Nix**: Base package manager with flakes support
- **Homebrew**: Legacy package manager (taking PATH precedence)
- **asdf**: Language version manager (taking PATH precedence)
- **direnv**: Automatic project environment activation (installed via Nix)

PATH precedence: `homebrew > asdf > nix` (ensures no collisions during transition)

## Migration Strategy

**⚠️ IMPORTANT**: We're transitioning to Home Manager for better declarative package management. This replaces the previous `nix-env` approach.

### Clean Slate Migration

Before starting, clean up existing `nix-env` installations to start fresh:

```bash
# List what's currently installed
nix-env -q

# Remove all packages (start with clean slate)
nix-env -e '*'

# Verify everything is removed
nix-env -q
```

### Home Manager Setup

#### 1. Install Home Manager
```bash
# Add Home Manager channel
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

# Install Home Manager
nix-shell '<home-manager>' -A install
```

#### 2. Create Home Manager config
Create `~/.config/home-manager/home.nix`:
```nix
{ config, pkgs, ... }:
let
  unstable = import <nixpkgs-unstable> { };
in
{
  home.username = "cwatkins";  # Replace with your username
  home.homeDirectory = "/Users/cwatkins";  # Replace with your home dir
  home.stateVersion = "24.05";

  programs.home-manager.enable = true;

  home.packages = (with pkgs; [
    awscli2
    curl
    direnv
    gh
    git
    gnugrep
    opentofu
    gnused
  ]) ++ (with unstable; [
    azure-cli
    goose-cli
    uv
  ]) ++ [
    (pkgs.google-cloud-sdk.withExtraComponents (with pkgs.google-cloud-sdk.components; [
      gke-gcloud-auth-plugin
    ]))
  ];
}
```

#### 3. Apply configuration
```bash
home-manager switch
```

### Ongoing Migration Process

For each tool, migrate from Homebrew to Home Manager:

#### 1. Remove from Homebrew
```bash
brew uninstall ripgrep
```

#### 2. Add to Home Manager config
Edit `~/.config/home-manager/home.nix`:
```nix
home.packages = (with pkgs; [
  # existing packages...
  ripgrep    # <- add new tool
  neovim     # <- add another
]) ++ (with unstable; [
  # unstable packages...
]);
```

#### 3. Apply changes
```bash
home-manager switch
```

**Benefits over `nix-env`:**
- **Truly declarative**: Removed packages are automatically uninstalled
- **Rollback support**: `home-manager generations` for easy rollbacks
- **Broader scope**: Manages dotfiles, services, shell config, not just packages
- **Atomic updates**: All-or-nothing updates prevent broken states

### 4. Test
Verify the tool works correctly from the Nix installation.

## Recommended Migration Order

1. **CLI tools first**: ripgrep, fd, bat, tree, jq, etc.
2. **Editors/terminal**: neovim, wezterm
3. **Language toolchains last**: Keep using asdf until fully ready

## Special Case: Migrating Bash

Since bash is critical to the entire system, it requires special handling:

### 1. Add bash to nix config
```nix
{ pkgs ? import <nixpkgs> {} }:

with pkgs; [
  direnv
  bash     # <- add gnu bash
]
```

### 2. Install nix bash
```bash
nix-env --set -f nix/base.nix
```

### 3. Add nix bash to system shells
```bash
# Add to /etc/shells
echo "$HOME/.nix-profile/bin/bash" | sudo tee -a /etc/shells

# Change your shell
chsh -s "$HOME/.nix-profile/bin/bash"
```

### 4. Start new shell session
```bash
# Start fresh shell to use nix bash
exec bash
```

### 5. Remove homebrew bash
```bash
brew uninstall bash
```

**Note**: `~/.nix-profile/bin/bash` is a symlink managed by nix that points to the current bash version in the nix store (`/nix/store/hash-bash-version/bin/bash`).

## Project Environments

For projects with `flake.nix`:
```bash
cd project-directory
echo "use flake" > .envrc
direnv allow
```

This automatically loads project-specific Nix environments.

## Rollback Strategy

If a tool doesn't work properly via Nix:
```bash
brew install tool-name  # Quick rollback
```

The PATH precedence ensures Homebrew takes priority while you fix the Nix configuration.

## Migration Status

### ✅ Migrated to Nix
- [x] direnv
- [x] uv (Python package manager)

### 🍺 Still on Homebrew
**Packages:**
- [ ] shellcheck
- [ ] coreutils  
- [ ] bash-completion
- [ ] neovim
- [ ] reattach-to-user-namespace
- [ ] bash
- [ ] grep
- [ ] pandoc
- [ ] librsvg (for pandoc)
- [ ] python (for pandoc)
- [ ] gpg
- [ ] git
- [ ] cosign
- [ ] lulu
- [ ] ripgrep (for neovim/telescope)

**Casks:**
- [ ] basictex (for pandoc)
- [ ] wezterm
- [ ] wireshark
- [ ] firefox@developer-edition

### 🔧 Still on asdf
- [ ] nodejs
- [ ] python
- [ ] go
- [ ] rust
- [ ] ruby
- [ ] terraform
- [ ] kubectl
- [ ] (other language toolchains)

## Commands

### Home Manager (New Approach)
- **Bootstrap setup**: `./i.sh --call main_macos`
- **Apply Home Manager config**: `home-manager switch`
- **Check installed packages**: `home-manager packages`
- **Rollback to previous generation**: `home-manager switch --rollback`
- **List generations**: `home-manager generations`

### Legacy nix-env (Deprecated)
- ~~**Update Nix packages**: `nix-env --set -f nix/base.nix`~~
- **Check what's installed**: `nix-env -q`
- **Remove all packages**: `nix-env -e '*'`
