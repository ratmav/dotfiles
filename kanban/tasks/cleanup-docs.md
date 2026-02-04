# 005: cleanup and document system transition

**milestone:** 1 - local experience

**dependencies:** 003-add-to-path, 004-audit-dead-files

## description

remove home-manager/nix-darwin and document cleanup process for transitioning existing systems to new architecture. aligns with nix-only-for-flakes philosophy. CLEANUP.md lives at repo root, removed after systems are clean.

## subtasks

- [ ] create CLEANUP.md at repo root
- [ ] kali system: remove home-manager
  - check if installed (`which home-manager`, `nix-env --query`)
  - check `~/.config/home-manager/`
  - check .bashrc for home-manager sourcing
  - remove completely if found
  - document steps in CLEANUP.md
- [ ] macos system: remove nix-darwin and home-manager
  - check for nix-darwin installation
  - check for home-manager installation
  - check .bashrc/.bash_profile for auto-generated sections
  - remove both completely if found
  - document steps in CLEANUP.md
- [ ] document other cleanup items in CLEANUP.md
  - packages installed wrong way (direnv via nix → homebrew)
  - old symlinks that need manual removal
  - conflicting configurations
  - what to uninstall before re-bootstrapping
- [ ] test fresh shell sessions on both systems
- [ ] verify dotfiles under ish control

## deliverable

home-manager and nix-darwin removed from both systems, CLEANUP.md documents the process, systems ready for clean re-bootstrap

## notes

**nix-only-for-flakes philosophy:**
nix is used ONLY for per-project dev environments (replacing asdf). NOT for system packages, GUI apps, nix-darwin, or home-manager. "live off the land" for everything else. ish manages dotfiles, not nix.

**why CLEANUP.md at root:**
one-time transition operation for existing systems, not permanent architecture documentation. lives at repo root for visibility during cleanup, can be removed after systems are clean.
