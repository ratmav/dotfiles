# Nix Migration Plan

This repo is transitioning from Homebrew + asdf to Nix on macOS while maintaining productivity during the migration.

## Current Setup

- **Nix**: Base package manager with flakes support
- **Homebrew**: Legacy package manager (taking PATH precedence)
- **asdf**: Language version manager (taking PATH precedence)
- **direnv**: Automatic project environment activation (installed via Nix)

PATH precedence: `homebrew > asdf > nix` (ensures no collisions during transition)

## Migration Strategy

Migrate tools one at a time from Homebrew to Nix:

### 1. Add tool to Nix config
Edit `nix/base.nix`:
```nix
{ pkgs ? import <nixpkgs> {} }:

with pkgs; [
  direnv
  ripgrep    # <- add new tool
  neovim     # <- add another
]
```

### 2. Remove from Homebrew
```bash
brew uninstall ripgrep
```

### 3. Update Nix packages
```bash
nix-env -if nix/base.nix
```

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
nix-env -if nix/base.nix
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

- **Bootstrap setup**: `./i.sh --call main_macos`
- **Update Nix packages**: `nix-env -if nix/base.nix`
- **Check what's installed**: `nix-env -q`
- **Remove Nix package**: `nix-env -e package-name`
