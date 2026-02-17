# implement package loading strategy

**milestone:** 1 - restructure

**dependencies:** standardize-package-naming (MUST complete first)

## problem

Current structure has ish framework inside `packages/`:
```
packages/
├── ish/              # Framework trying to load packages
└── ish-dotfiles/     # A package to load
```

If package scanner loads everything in `packages/`, it tries to load ish as a package of itself → **circular dependency** and bootstrapping paradox.

Additional issue: If ish-dotfiles becomes a submodule of ish (with ish in `packages/`), we get nested submodules (ish-dotfiles/test/bats/) which are painful to manage.

## solution

Separate framework from packages using simple `~/.ish/` structure:

**Development mode:**
```
~/Source/dotfiles/
├── ish -> core/bin/ish                 # Symlink for convenience
├── core/                               # Framework (mirrors ~/.ish/core/)
│   ├── bin/ish                         # Entry point
│   ├── source/                         # Framework modules
│   ├── test/                           # Framework tests
│   └── docs/                           # Framework docs
└── packages/                           # Packages (mirrors ~/.ish/packages/)
    ├── ish-dotfiles/                   # A package (peer, not child)
    └── [future packages]/
```

**Installed mode (future):**
```
~/.ish/
├── core/                               # Framework (immutable)
│   ├── bin/ish                         # Entry point
│   ├── source/                         # Framework modules
│   ├── test/                           # Framework tests
│   └── docs/                           # Framework docs
└── packages/                           # Installed packages (mutable)
    ├── ish-dotfiles/
    └── ish-foo/
```

**Benefits:**
- Framework clearly separated, never scanned as package
- No nested submodules (ish and ish-dotfiles are peer repos)
- Simple single-directory installation (~/.ish/)
- Development structure mirrors installed structure exactly
- Future-proof for Phase 6 split

## subtasks

### Phase 1: Document the Solution (this session)

- [x] Create `packages/ish/docs/architecture/package_loading.md`
  - Document framework vs packages separation
  - Explain development vs installed mode paths
  - Define loading order and discovery rules

- [x] Update `packages/ish/docs/architecture/overview.md`
  - Close open question #8 with core/ decision
  - Document rationale: prevents bootstrapping recursion

- [x] Update `packages/ish/docs/architecture/module_loading_system.md`
  - Correct paths to show core/ structure (future state)
  - Update example code with correct scanner implementation

- [x] Update dependent tasks (registry, install in later phases)
  - Find tasks that reference package loading
  - Update them to reference core/ structure

### Phase 2: Execute Restructure (COMPLETE)

- [x] Move framework directory
  ```bash
  git mv packages/ish core
  ```

- [x] Keep source/ directory (no rename needed)
  - Framework modules stay in `core/source/`
  - No structural changes to module layout

- [x] Update entry point path calculation in `core/bin/ish`
  ```bash
  # Fixed: ISH_CORE="${ISH_ROOT}/core" (not core/source)
  # All source statements updated to include /source/ explicitly
  ```

- [x] Rename ish-dotfiles to ish-ratfiles
  ```bash
  git mv packages/ish-dotfiles packages/ish-ratfiles
  ```
  - Renamed all `ish_dotfiles_*` functions to `ish_ratfiles_*`
  - Updated command routing: `ish dotfiles` → `ish ratfiles`
  - Updated source statements
  - Updated tests

- [x] Update path references in `packages/ish-ratfiles/source/*.sh`
  - Changed all source statements to use `${ISH_CORE}/source/` pattern
  - Updated framework module references

- [x] Update root `ish` symlink
  ```bash
  ln -sf core/bin/ish ish
  ```

- [x] Fixed architectural violations
  - Extracted help functions to child modules (utils/exists, git/clean, bootstrap/macos/homebrew)
  - Removed duplicate tests (tests live where code lives)
  - Fixed .gitmodules naming to match actual paths

- [x] Update test files
  - Updated all test paths to use `${ISH_CORE}/source/` pattern
  - Fixed inline bash commands in tests
  - Verified test invocation still works

- [x] Run full verification - 98/98 tests passing

### Phase 3: Install Command (future session)

- [ ] Implement `ish_filesystem_line_in_file` module
  - Idempotent line insertion for PATH management
  - Check if line exists before adding
  - Used by `ish install` command

- [ ] Implement `ish install` command
  - Clone framework to ~/.ish/core/
  - Add ~/.ish/core/bin to PATH using ish_filesystem_line_in_file
  - Update ~/.bashrc and ~/.zshrc

## deliverable

- Framework in `core/`, packages in `packages/` (installed: `~/.ish/core/` and `~/.ish/packages/`)
- Clear separation prevents bootstrapping recursion
- Package scanner only targets `packages/`
- PATH management via `ish install` command using idempotent line insertion
- Documentation explains architecture and loading order
- All tests pass after restructure

## critical files

### Documentation (Phase 1) - uses current paths
- `packages/ish/docs/architecture/package_loading.md` (NEW - created)
- `packages/ish/docs/architecture/overview.md` (UPDATE - closed question #8)
- `packages/ish/docs/architecture/module_loading_system.md` (UPDATE - shows future paths)
- `packages/ish/kanban/tasks/implement-registry.md` (UPDATE - future paths)
- `packages/ish/kanban/tasks/package-system.md` (UPDATE - references)

### Code (Phase 2) - creates new paths
- `packages/ish/` → `core/` (git mv)
- `core/bin/ish` (UPDATE - path calculation)
- `packages/ish-dotfiles/source/*.sh` (UPDATE - framework references)
- `core/source/filesystem.sh` (CREATE - ish_filesystem_line_in_file module)
- `core/source/install.sh` (CREATE - ish install command with PATH management)
- Root `ish` symlink (UPDATE - target)

## verification

After Phase 2 restructure:

```bash
# Path calculation works
./ish help                           # Should display help

# Framework modules load
./ish platform os                    # Should detect OS
./ish utils tui info --message=test  # Should show colored output

# Package routing works
./ish dotfiles help                  # Should show dotfiles commands
./ish dotfiles bootstrap help        # Should show bootstrap platforms

# Tests pass
./ish test all                       # All ish framework tests
./ish dotfiles test all              # All dotfiles package tests

# Symlink works
./ish kanban show                    # Should display board
```
