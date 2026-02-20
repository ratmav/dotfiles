# restructure dotfiles package

**phase:** 2

**dependencies:** none

## description

make ratfiles package use ish utilities wherever possible, hoist reusable patterns into core, and move dotfile configs into the package data directory.

## subtasks

### 1. audit ratfiles for ish utility usage
- [ ] read all files in `packages/ish-ratfiles/source/`
- [ ] identify patterns that duplicate ish utilities
- [ ] identify patterns that should be hoisted to core
- [ ] document findings: what to replace, what to hoist

### 2. hoist generic patterns to core
- [ ] create `core/source/file.sh` module for file operations:
  - `ish_file_symlink` - create symlink with error handling
  - `ish_file_copy` - copy file/directory
  - `ish_file_exists` - check file existence
  - `ish_file_ensure_dir` - ensure directory exists
- [ ] add tests for new core utilities

### 3. refactor ratfiles to use ish utilities
- [ ] replace custom error handling with `ish_tui_*`
- [ ] replace file operations with `ish_file_*` utilities
- [ ] test each refactored module

### 4. copy dotfiles to package data directory
- [ ] copy config files to `packages/ish-ratfiles/data/`:
  - `.bash_profile`, `.bashrc`, `.gitignore`, `.gitignore_global`
  - `.gitmodules`, `.luacheckrc`, `neovim.lua`, `wezterm.lua`
  - `nvim/` (entire directory)
- [ ] keep originals at root during transition

### 5. fix scaffold tests
- [ ] update test files to demonstrate router help pattern
- [ ] ensure tests pass

### 6. document router help convention
- [ ] update `core/docs/conventions.md` — router help pattern
- [ ] update `core/docs/architecture/package_system.md` — scaffold example

## deliverable

ratfiles package uses ish utilities consistently. generic patterns hoisted to core. dotfile configs in package data directory.
