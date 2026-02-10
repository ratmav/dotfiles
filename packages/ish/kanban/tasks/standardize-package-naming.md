# standardize package naming convention

**milestone:** 1 - restructure

**dependencies:** none (BLOCKING all other phase 1 work)

## description

CRITICAL: Resolve package naming inconsistency before any further refactoring. Currently have mixed `ish_*` and `dotfiles_*` functions. Need consistent convention for package loading and namespace collision detection.

## decision

**Package naming convention:**
- Package directory name: `packages/ish-<name>/` (hyphenated)
- Function prefix: `ish_<name>_*` (underscored)
- Examples:
  - Package: `packages/ish/` → functions: `ish_core_*`, `ish_kanban_*`, etc.
  - Package: `packages/ish-dotfiles/` → functions: `ish_dotfiles_*`
  - Future: `packages/ish-docker/` → functions: `ish_docker_*`

**Why ish_ prefix for all ish ecosystem packages:**
- Prevents namespace collisions (generic "dotfiles" too common)
- Makes ownership clear (all ish_* functions are ish ecosystem)
- Enables namespace validation in registry
- Follows vision.md examples (ish-docker, ish-kubernetes)

## subtasks

**Phase 1: Rename dotfiles package and directory:**
- [ ] Rename `packages/dotfiles/` → `packages/ish-dotfiles/`
- [ ] Update all `source` statements that reference dotfiles package
- [ ] Update test paths and imports
- [ ] Update .gitmodules if applicable

**Phase 2: Rename all dotfiles functions:**
- [ ] Audit: grep for all `bootstrap_*`, `git_*`, `nix_*` functions in dotfiles package
- [ ] Rename all to `ish_dotfiles_*` prefix:
  - `bootstrap_posix_*` → `ish_dotfiles_bootstrap_posix_*`
  - `bootstrap_macos_*` → `ish_dotfiles_bootstrap_macos_*`
  - `bootstrap_kali_*` → `ish_dotfiles_bootstrap_kali_*`
  - `git_*` → `ish_dotfiles_git_*`
  - `nix_*` → `ish_dotfiles_nix_*`
- [ ] Update all call sites
- [ ] Update all routing functions
- [ ] Update all help text

**Phase 3: Update CLI routing:**
- [ ] Main ish router recognizes `ish dotfiles` namespace
- [ ] CLI: `ish dotfiles bootstrap macos all` routes to `ish_dotfiles_bootstrap_macos_all()`
- [ ] Verify help text at all levels

**Phase 4: Update tests:**
- [ ] Update test function names
- [ ] Update test assertions
- [ ] Verify all tests pass

**Phase 5: Document convention:**
- [ ] Update `docs/conventions.md` with package naming rules
- [ ] Add examples showing ish_<package>_* pattern
- [ ] Document CLI routing for packages

## deliverable

All functions consistently named with `ish_<package>_*` prefix. Package structure supports loading strategy and namespace validation.

## critical files

**Rename directory:**
- `packages/dotfiles/` → `packages/ish-dotfiles/`

**Update routing:**
- `ish` (main entry point)
- `packages/ish-dotfiles/source/*.sh` (all routers)

**Update functions (comprehensive rename):**
- `packages/ish-dotfiles/source/bootstrap/*.sh`
- `packages/ish-dotfiles/source/git/*.sh`
- `packages/ish-dotfiles/source/nix.sh`

**Update tests:**
- `packages/ish-dotfiles/test/unit/*.bats`
- `packages/ish-dotfiles/test/integration/*.bats`

**Update docs:**
- `packages/ish/docs/conventions.md`

## verification

```bash
# No bare dotfiles_* functions should exist
grep -r "^dotfiles_" packages/ish-dotfiles/source/
# (should return nothing)

# All functions should use ish_dotfiles_* prefix
grep -r "^ish_dotfiles_" packages/ish-dotfiles/source/
# (should return all public functions)

# CLI should work
./ish dotfiles bootstrap macos all
./ish dotfiles git clean prune
```

## notes

This is BLOCKING. Must be completed before:
- Task 4: ishen-dotfiles-package (depends on consistent naming)
- Phase 2: FP core (packages need to load ish_core_* functions)
- Phase 3: Registry (namespace validation requires consistent prefixes)
