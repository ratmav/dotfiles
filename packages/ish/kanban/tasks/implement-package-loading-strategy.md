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

Separate framework from packages following XDG Base Directory Spec:

**Development mode:**
```
~/Source/dotfiles/
├── ish -> lib/ish/bin/ish              # Symlink for convenience
├── lib/
│   └── ish/                            # Framework (never scanned as package)
│       ├── bin/ish                     # Entry point
│       ├── lib/                        # Core modules
│       ├── test/                       # Framework tests
│       └── docs/                       # Framework docs
└── packages/
    ├── ish-dotfiles/                   # A package (peer, not child)
    └── [future packages]/
```

**Installed mode (future):**
```
~/.local/
├── bin/ish -> ../lib/ish/bin/ish
├── lib/ish/                            # Framework (immutable)
└── share/ish/packages/                 # Packages (mutable)
    ├── github-ratmav-dotfiles/
    └── github-user-foo/
```

**Benefits:**
- Framework clearly separated, never scanned as package
- No nested submodules (ish and ish-dotfiles are peer repos)
- XDG compliant paths
- Works in both development and installed modes
- Future-proof for Phase 6 split

## subtasks

### Phase 1: Document the Solution (this session)

- [x] Create `packages/ish/docs/architecture/package_loading.md`
  - Document framework vs packages separation
  - Explain development vs installed mode paths
  - Define loading order and discovery rules

- [x] Update `packages/ish/docs/architecture/overview.md`
  - Close open question #8 with lib/ish decision
  - Document rationale: prevents bootstrapping recursion

- [x] Update `packages/ish/docs/architecture/module_loading_system.md`
  - Correct paths to show lib/ish structure (future state)
  - Update example code with correct scanner implementation

- [x] Update dependent tasks (registry, install in later phases)
  - Find tasks that reference package loading
  - Update them to reference lib/ish structure

### Phase 2: Execute Restructure (future session)

- [ ] Move framework directory
  ```bash
  git mv packages/ish lib/ish
  ```

- [ ] Rename source/ to lib/ for clarity
  ```bash
  mkdir -p lib/ish/lib
  git mv lib/ish/source/* lib/ish/lib/
  rmdir lib/ish/source
  ```

- [ ] Update entry point path calculation in `lib/ish/bin/ish`
  ```bash
  # Old (assumes packages/ish/bin/ish)
  ISH_PACKAGES_DIR=$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/../.." && pwd -P)

  # New (assumes lib/ish/bin/ish)
  ISH_ROOT=$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/../.." && pwd -P)
  ISH_LIB="${ISH_ROOT}/lib/ish/lib"
  ISH_PACKAGES="${ISH_ROOT}/packages"
  ```

- [ ] Update path references in `packages/ish-dotfiles/source/*.sh`
  - Change `${ISH_PACKAGES_DIR}/ish/` to `${ISH_LIB}/`
  - Update framework module references

- [ ] Update root `ish` symlink
  ```bash
  ln -sf lib/ish/bin/ish ish
  ```

- [ ] Update test files
  - Update paths to framework modules
  - Verify test invocation still works

- [ ] Run full verification (see below)

## deliverable

- Framework in `lib/ish/`, packages in `packages/`
- Clear separation prevents bootstrapping recursion
- Package scanner only targets `packages/`
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
- `packages/ish/` → `lib/ish/` (git mv)
- `lib/ish/bin/ish` (UPDATE - path calculation)
- `packages/ish-dotfiles/source/*.sh` (UPDATE - framework references)
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
