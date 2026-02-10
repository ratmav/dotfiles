# standardize package naming convention

**milestone:** 1 - restructure

**dependencies:** none (BLOCKING all other phase 1 work)

## description

CRITICAL: Resolve package naming inconsistency across BOTH packages before any further refactoring. Currently have mixed naming with no consistent `ish_` prefix. Need full namespace consistency for package loading and collision detection.

**Scope:** ~77 functions across ~30 files in both ish and dotfiles packages.

## decision

**Package naming convention:**
- Package directory name: `packages/ish-<name>/` (hyphenated)
- Function prefix: `ish_<name>_*` (underscored)
- Examples:
  - Package: `packages/ish/` → functions: `ish_kanban_*`, `ish_utils_*`, `ish_platform_*`
  - Package: `packages/ish-dotfiles/` → functions: `ish_dotfiles_*`
  - Future: `packages/ish-docker/` → functions: `ish_docker_*`

**Why ish_ prefix for all ish ecosystem packages:**
- Prevents namespace collisions (`utils_*`, `platform_*` are too generic)
- Makes ownership clear (all ish_* functions are ish ecosystem)
- Enables namespace validation in registry
- Follows vision.md examples (ish-docker, ish-kubernetes)

## stage 1: ish package (core utilities)

**Scope:** 35 functions in packages/ish/source/

### subtasks

**1.1: Rename ish package functions:**
- [x] Audit: list all functions missing `ish_` prefix (35 functions)
  ```bash
  kanban_*    → ish_kanban_*     (13 functions)
  utils_*     → ish_utils_*      (18 functions)
  platform_*  → ish_platform_*   (4 functions)
  ```
- [x] Rename all function definitions
- [x] Update all call sites within ish package
- [x] Update all routing functions
- [x] Update all help text

**1.2: Update ish package tests:**
- [x] Update test function references in unit tests
- [x] Update test function references in integration tests
- [x] Verify all ish package tests pass

**1.3: Verify stage 1:**
```bash
# All ish package functions should have ish_ prefix
grep -r "^[a-z_]*() {" packages/ish/source/ | grep -v "^_" | grep -v "^ish_"
# (should return nothing)

# Tests pass
./ish test all
```

## stage 2: dotfiles package

**Scope:** ~42 functions in packages/dotfiles/source/

### subtasks

**2.1: Rename dotfiles package directory:**
- [ ] Rename `packages/dotfiles/` → `packages/ish-dotfiles/`
- [ ] Update all `source` statements that reference dotfiles package
- [ ] Update test paths and imports
- [ ] Update .gitmodules if applicable

**2.2: Rename dotfiles package functions:**
- [ ] Audit: list all functions needing prefix (42 functions)
  ```bash
  bootstrap_*  → ish_dotfiles_bootstrap_*  (26 functions)
  git_*        → ish_dotfiles_git_*        (4 functions)
  nix_*        → ish_dotfiles_nix_*        (3 functions)
  dotfiles_*   → ish_dotfiles_*            (9 functions)
  ```
- [ ] Rename all function definitions
- [ ] Update all call sites within dotfiles package
- [ ] Update all routing functions
- [ ] Update all help text

**2.3: Move dotfiles tests to dotfiles package:**
- [ ] Move `packages/ish/test/integration/bootstrap*` → `packages/dotfiles/test/integration/`
- [ ] Move `packages/ish/test/integration/git*` → `packages/dotfiles/test/integration/`
- [ ] Move `packages/ish/test/integration/nix.bats` → `packages/dotfiles/test/integration/`
- [ ] Update test paths in moved files (if needed)
- [ ] Update `packages/dotfiles/source/test.sh` to point to correct test locations

**2.4: Update dotfiles package tests:**
- [ ] Update test function references in unit tests
- [ ] Update test function references in integration tests
- [ ] Verify all dotfiles package tests pass

**2.5: Update main ish router:**
- [ ] Update `ish` entry point to reference `packages/ish-dotfiles/`
- [ ] Verify CLI routing: `./ish dotfiles bootstrap macos all`

**2.6: Verify stage 2:**
```bash
# All dotfiles functions should have ish_dotfiles_ prefix
grep -r "^[a-z_]*() {" packages/ish-dotfiles/source/ | grep -v "^_" | grep -v "^ish_dotfiles_"
# (should return nothing)

# Tests pass
./ish dotfiles test all
./ish test all
```

## deliverable

All functions consistently named with `ish_<package>_*` prefix across both packages. Package structure supports loading strategy and namespace validation.

## critical files

**Stage 1 (ish package):**
- `packages/ish/source/kanban.sh` + `kanban/*.sh`
- `packages/ish/source/utils.sh` + `utils/**/*.sh`
- `packages/ish/source/platform.sh`
- `packages/ish/test/**/*.bats`

**Stage 2 (dotfiles package):**
- `packages/dotfiles/` → `packages/ish-dotfiles/` (directory rename)
- `ish` (main entry point)
- `packages/ish-dotfiles/source/bootstrap/*.sh`
- `packages/ish-dotfiles/source/git/*.sh`
- `packages/ish-dotfiles/source/nix.sh`
- `packages/ish-dotfiles/source/dotfiles.sh` (router)
- `packages/ish-dotfiles/test/**/*.bats`
- Move tests from `packages/ish/test/integration/{bootstrap,git,nix}*` to `packages/ish-dotfiles/test/integration/`

**Documentation:**
- `packages/ish/docs/conventions.md`

## final verification

```bash
# No functions without ish_ prefix in either package
grep -r "^[a-z_]*() {" packages/ish/source/ packages/ish-dotfiles/source/ | grep -v "^_" | grep -v "^ish_"
# (should return nothing)

# No dotfiles tests remaining in ish package
ls packages/ish/test/integration/ | grep -E "(bootstrap|git|nix)"
# (should return nothing)

# All tests pass
./ish test all
./ish dotfiles test all

# CLI works correctly
./ish kanban show
./ish utils exists --executable=bash
./ish platform os
./ish dotfiles bootstrap help
```

## notes

**Two-stage approach:**
- Stage 1 first: Core utilities (ish package) establish foundation
- Stage 2 second: Dotfiles package depends on renamed core utilities
- Each stage includes tests and verification

**BLOCKING:** Must be completed before:
- Task 4: implement-package-loading-strategy (depends on consistent naming)
- Phase 2: FP core (packages need to load ish_core_* functions)
- Phase 3: Registry (namespace validation requires consistent prefixes)
