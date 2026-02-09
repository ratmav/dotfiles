# complete namespace restructure

**milestone:** 1 - restructure

**parent task:** execute migration_path.md Step 1 (12-step restructure)

**dependencies:** fix-module-loading.md (completed)

## description

Complete the namespace alignment by removing "self" concept and adding explicit package namespaces. This does three things in one cohesive change to avoid intermediate broken states:

1. Remove "self" namespace from ish package
2. Add "dotfiles" package namespace
3. Split tests by package

**Current state:**
- CLI: `ish self test unit`, `ish bootstrap posix`, `ish git clean`
- Files: `packages/ish/source/self/test.sh`, `packages/ish/source/self/lint.sh`
- Functions: `self_test_*`, `self_lint_*`

**Target state:**
- CLI: `ish test unit`, `ish dotfiles bootstrap posix`, `ish dotfiles git clean`
- Files: `packages/ish/source/test.sh`, `packages/dotfiles/source/test.sh`
- Functions: `ish_test_*`, `dotfiles_test_*`

**Why one task:** Doing this incrementally creates multiple intermediate states. Doing it all at once prevents complexity explosion.

## subtasks

### 1. Remove "self" namespace from ish package

**File operations:**
- [ ] Move `packages/ish/source/self/test.sh` → `packages/ish/source/test.sh`
- [ ] Move `packages/ish/source/self/lint.sh` → `packages/ish/source/lint.sh`
- [ ] Delete `packages/ish/source/self.sh`
- [ ] Delete `packages/ish/source/self/` directory

**Function renames:**
- [ ] `self_test_all` → `ish_test_all`
- [ ] `self_test_unit` → `ish_test_unit`
- [ ] `self_test_integration` → `ish_test_integration`
- [ ] `self_lint_all` → `ish_lint_all`
- [ ] `self_lint_bash` → `ish_lint_bash`

**Routing updates in `packages/ish/bin/ish`:**
- [ ] Remove `self)` case block
- [ ] Add `test)` case block at top level
- [ ] Add `lint)` case block at top level
- [ ] Update `ish_help()` to show test/lint instead of self

### 2. Add "dotfiles" package namespace

**Create dotfiles router:**
- [ ] Create `packages/dotfiles/source/dotfiles.sh` with help and routing

**Routing updates in `packages/ish/bin/ish`:**
- [ ] Add `dotfiles)` case block
- [ ] Route bootstrap, git, nix under dotfiles
- [ ] Remove bootstrap, git, nix from top level
- [ ] Update `ish_help()` to show dotfiles instead of bootstrap/git/nix

**Create dotfiles test/lint modules:**
- [ ] Create `packages/dotfiles/source/test.sh` with `dotfiles_test_*` functions
- [ ] Create `packages/dotfiles/source/lint.sh` with `dotfiles_lint_*` functions

### 3. Split tests by package

**Directory structure:**
- [ ] Move `test/unit/` → `packages/ish/test/unit/`
- [ ] Move `test/integration/` → `packages/ish/test/integration/`
- [ ] Create `packages/dotfiles/test/unit/` (empty for now)
- [ ] Create `packages/dotfiles/test/integration/` (empty for now)

**Update test paths:**
- [ ] Update paths in `packages/ish/source/test.sh` to use new locations
- [ ] Update paths in `packages/dotfiles/source/test.sh` for future dotfiles tests

### 4. Verify functionality

**ish package commands:**
- [ ] `./ish test unit` runs ish unit tests
- [ ] `./ish lint all` lints ish package
- [ ] `./ish help` shows test/lint in command list

**dotfiles package commands:**
- [ ] `./ish dotfiles` shows dotfiles help
- [ ] `./ish dotfiles test unit` works (currently no tests)
- [ ] `./ish dotfiles bootstrap posix help` works
- [ ] `./ish dotfiles git clean prune --dry-run` works

**Existing commands still work:**
- [ ] `./ish kanban show`
- [ ] `./ish utils exists --executable=bash`
- [ ] `./ish platform os`

## deliverable

Namespace-aligned CLI that matches package structure. "self" concept removed. Tests split by package.

## critical files

- `packages/ish/bin/ish` - Entry point routing (major changes)
- `packages/ish/source/self.sh` - DELETE
- `packages/ish/source/self/test.sh` - MOVE to `packages/ish/source/test.sh`
- `packages/ish/source/self/lint.sh` - MOVE to `packages/ish/source/lint.sh`
- `packages/dotfiles/source/dotfiles.sh` - CREATE (new router)
- `packages/dotfiles/source/test.sh` - CREATE
- `packages/dotfiles/source/lint.sh` - CREATE

## implementation notes

**Routing pattern for dotfiles:**
```bash
dotfiles)
  shift
  case "${1-}" in
    test|lint|bootstrap|git|nix)
      source "${ISH_PACKAGES_DIR}/dotfiles/source/${1}.sh"
      dotfiles_${1}_route "$@"
      ;;
    help|"")
      dotfiles_help
      ;;
    *)
      dotfiles_help
      utils_tui_error --message="unknown dotfiles command: ${1-}"
      ;;
  esac
  ;;
```

**Help text for dotfiles router:**
```bash
dotfiles_help() {
  utils_stream_multiline_stderr <<EOF
usage: ish dotfiles [command]

dotfiles package - configuration and environment management

commands:
  test         run tests for dotfiles package
  lint         run linters for dotfiles package
  bootstrap    setup development environment
  git          git utility functions
  nix          nix package manager utilities
EOF
}
```

**Updated main help:**
```bash
commands:
  test         run tests for ish package
  lint         run linters for ish package
  kanban       project task management
  platform     platform detection
  utils        utility functions
  dotfiles     dotfiles package (bootstrap, git, nix)
  help         show this help message
```
