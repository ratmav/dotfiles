# ishen dotfiles package (use ish utilities, hoist reusable code)

**milestone:** 1 - restructure

**dependencies:** fix-cli-consistency.md (completed)

## description

Make dotfiles package use ish utilities wherever possible and hoist generically useful patterns into ish. Also copy actual dotfile configurations into the package data directory and fix test scaffolds to demonstrate proper router help patterns.

**Goals:**
1. Replace duplicate code in dotfiles with ish utilities
2. Identify and hoist generic patterns to ish (array handling, file/symlink operations)
3. Copy actual dotfile configs to `packages/dotfiles/data/`
4. Fix scaffold tests to demonstrate router help pattern
5. Document router help convention
6. Update scaffolding task to include router help

## current state

**Dotfiles package has duplicate patterns:**
- Custom error handling (should use `utils_tui_*`)
- Array/list operations (should use ish utilities or hoist to ish)
- File/symlink operations (should be hoisted to ish as generic `file` module)

**Actual dotfiles are at repo root:**
```
.bash_profile
.bashrc
.gitignore
.gitignore_global
.gitmodules
.luacheckrc
neovim.lua
wezterm.lua
nvim/
```

**Scaffold tests don't demonstrate router pattern:**
- `packages/dotfiles/test/unit/hello.bats` - generic echo test
- `packages/dotfiles/test/integration/hello.bats` - tests `./ish dotfiles help`
- Should demonstrate testing a router help command

## target state

**Dotfiles uses ish utilities:**
- All TUI operations use `utils_tui_*`
- Array operations use ish utilities (or new ish utilities if hoisted)
- File operations use ish `file_*` module (to be created)

**Ish has new generic modules:**
- `packages/ish/source/file.sh` - symlink, copy, move operations
- Enhanced array/list utilities in `utils/` or new module

**Dotfiles configs in package:**
```
packages/dotfiles/data/
├── .bash_profile
├── .bashrc
├── .gitignore
├── .gitignore_global
├── .gitmodules
├── .luacheckrc
├── neovim.lua
├── wezterm.lua
└── nvim/
    └── (entire neovim config)
```

**Scaffold tests demonstrate router pattern:**
```bash
# packages/dotfiles/test/unit/hello.bats
@test "dotfiles router help shows usage" {
  run ./ish dotfiles help
  assert_success
  assert_output --partial "usage: ish dotfiles"
}

# packages/dotfiles/test/integration/hello.bats
@test "dotfiles bootstrap router help shows usage" {
  run ./ish dotfiles bootstrap help
  assert_success
  assert_output --partial "usage: ish dotfiles bootstrap"
}
```

## subtasks

### 1. Move dotfiles tests to dotfiles package
- [ ] Move `packages/ish/test/integration/bootstrap.bats` → `packages/dotfiles/test/integration/bootstrap.bats`
- [ ] Move `packages/ish/test/integration/bootstrap/` → `packages/dotfiles/test/integration/bootstrap/`
- [ ] Move `packages/ish/test/integration/git.bats` → `packages/dotfiles/test/integration/git.bats`
- [ ] Move `packages/ish/test/integration/git/` → `packages/dotfiles/test/integration/git/`
- [ ] Move `packages/ish/test/integration/nix.bats` → `packages/dotfiles/test/integration/nix.bats`
- [ ] Update test helper paths in moved tests (change `../test_helper` to correct relative path)
- [ ] Verify `./ish test integration` only runs ish tests
- [ ] Verify `./ish dotfiles test integration` runs dotfiles tests

### 2. Audit dotfiles for ish utility usage
- [ ] Read all files in `packages/dotfiles/source/`
- [ ] Identify patterns that duplicate ish utilities
- [ ] Identify patterns that should be hoisted to ish
- [ ] Document findings: what to replace, what to hoist

### 3. Hoist generic patterns to ish
- [ ] Create `packages/ish/source/file.sh` module for file operations:
  - `file_symlink` - create symlink with error handling
  - `file_copy` - copy file/directory
  - `file_exists` - check file existence
  - `file_ensure_dir` - ensure directory exists
- [ ] Add array/list utilities to ish (if needed)
- [ ] Add tests for new ish utilities

### 4. Refactor dotfiles to use ish utilities
- [ ] Replace custom error handling with `utils_tui_*`
- [ ] Replace file operations with `file_*` utilities
- [ ] Replace array operations with ish utilities
- [ ] Test each refactored module

### 5. Copy dotfiles to package data directory
- [ ] Create `packages/dotfiles/data/` directory
- [ ] Copy `.bash_profile` to `packages/dotfiles/data/.bash_profile`
- [ ] Copy `.bashrc` to `packages/dotfiles/data/.bashrc`
- [ ] Copy `.gitignore` to `packages/dotfiles/data/.gitignore`
- [ ] Copy `.gitignore_global` to `packages/dotfiles/data/.gitignore_global`
- [ ] Copy `.gitmodules` to `packages/dotfiles/data/.gitmodules`
- [ ] Copy `.luacheckrc` to `packages/dotfiles/data/.luacheckrc`
- [ ] Copy `neovim.lua` to `packages/dotfiles/data/neovim.lua`
- [ ] Copy `wezterm.lua` to `packages/dotfiles/data/wezterm.lua`
- [ ] Copy `nvim/` to `packages/dotfiles/data/nvim/` (entire directory)
- [ ] Keep originals at root (don't move, copy)

### 6. Fix scaffold tests to demonstrate router help
- [ ] Update `packages/dotfiles/test/unit/hello.bats`:
  - Test dotfiles router help
  - Test a module router help (e.g., bootstrap)
- [ ] Update `packages/dotfiles/test/integration/hello.bats`:
  - Test deeper router help (e.g., bootstrap posix)
- [ ] Ensure tests pass

### 7. Document router help convention
- [ ] Update `packages/ish/docs/conventions.md` CLI section:
  - Document that all routers must support `help` command
  - Show pattern: `help|"")` in case statements
  - Include example code
- [ ] Update `packages/ish/docs/architecture/package_types.md`:
  - Add router help pattern to scaffold example
  - Show test pattern for router help

### 8. Update scaffolding task
- [ ] Read `packages/ish/kanban/tasks/scaffolding.md`
- [ ] Add router help requirement to scaffolding checklist
- [ ] Include help test template in scaffolding output

## deliverable

Dotfiles package uses ish utilities consistently. Generic patterns hoisted to ish for reuse. Actual dotfile configs in package. Scaffold tests and docs demonstrate proper router help pattern.

## critical files

**Move dotfiles tests:**
- `packages/ish/test/integration/bootstrap.bats` → `packages/dotfiles/test/integration/bootstrap.bats` - MOVE
- `packages/ish/test/integration/bootstrap/` → `packages/dotfiles/test/integration/bootstrap/` - MOVE
- `packages/ish/test/integration/git.bats` → `packages/dotfiles/test/integration/git.bats` - MOVE
- `packages/ish/test/integration/git/` → `packages/dotfiles/test/integration/git/` - MOVE
- `packages/ish/test/integration/nix.bats` → `packages/dotfiles/test/integration/nix.bats` - MOVE

**New ish utilities:**
- `packages/ish/source/file.sh` - CREATE
- `packages/ish/test/unit/file.bats` - CREATE
- `packages/ish/test/integration/file.bats` - CREATE

**Refactor dotfiles:**
- `packages/dotfiles/source/bootstrap/*.sh` - UPDATE (use ish utilities)
- `packages/dotfiles/source/git/*.sh` - UPDATE (use ish utilities)
- `packages/dotfiles/source/nix.sh` - UPDATE (use ish utilities)

**Copy dotfiles:**
- `packages/dotfiles/data/` - CREATE directory
- `packages/dotfiles/data/.bash_profile` - COPY from root
- `packages/dotfiles/data/.bashrc` - COPY from root
- `packages/dotfiles/data/.gitignore` - COPY from root
- `packages/dotfiles/data/.gitignore_global` - COPY from root
- `packages/dotfiles/data/.gitmodules` - COPY from root
- `packages/dotfiles/data/.luacheckrc` - COPY from root
- `packages/dotfiles/data/neovim.lua` - COPY from root
- `packages/dotfiles/data/wezterm.lua` - COPY from root
- `packages/dotfiles/data/nvim/` - COPY from root

**Fix scaffolds:**
- `packages/dotfiles/test/unit/hello.bats` - UPDATE
- `packages/dotfiles/test/integration/hello.bats` - UPDATE

**Documentation:**
- `packages/ish/docs/conventions.md` - UPDATE (router help convention)
- `packages/ish/docs/architecture/package_types.md` - UPDATE (scaffold example)
- `packages/ish/kanban/tasks/scaffolding.md` - UPDATE (router help requirement)

## benefits

1. **Code reuse**: Dotfiles uses ish utilities, less duplication
2. **Generic utilities**: File operations available to all packages
3. **Package completeness**: Dotfiles has its data in the package
4. **Better scaffolds**: Examples show proper router help pattern
5. **Maintainability**: Common patterns in one place (ish)
6. **Consistency**: Same utilities across all packages

## verification

```bash
# Ish file utilities work
./ish file symlink --source=foo --target=bar
./ish file copy --source=foo --target=baz

# Dotfiles still function
./ish dotfiles bootstrap posix all
./ish dotfiles git clean prune --dry-run

# Tests pass
./ish test unit
./ish test integration
./ish dotfiles test unit
./ish dotfiles test integration

# Scaffold tests demonstrate router help
cat packages/dotfiles/test/unit/hello.bats  # shows router help test
cat packages/dotfiles/test/integration/hello.bats  # shows router help test
```

## notes

**Hoisting philosophy:**
- Only hoist patterns that are **generically useful** across packages
- Symlink/file operations: generic ✓
- Platform-specific bootstrap: not generic ✗
- Array/list utilities: generic if used in multiple places ✓

**Keep originals at root:**
- Don't move `.bashrc`, `.bash_profile`, etc. from root
- Copy them to `packages/dotfiles/data/`
- Root files stay for backward compatibility during transition
