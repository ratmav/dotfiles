# fix module loading with ISH_PACKAGES_DIR

**milestone:** 1 - restructure

**parent task:** execute migration_path.md Step 1 (12-step restructure)

**dependencies:** source files moved to packages/ structure (completed)

## description

Fix 28 broken source statements after Phase 1 Chunk 2 restructure using `ISH_PACKAGES_DIR` variable.

Files were moved from `bash/` to package structure, breaking all source paths. Need a solution that:
- Works now (repo structure)
- Works later (registry structure in Phase 3)
- Makes package boundaries explicit
- Requires zero refactoring during registry transition

## subtasks

- [ ] Fix entry point (`packages/ish/bin/ish`)
  - Add ISH_PACKAGES_DIR computation and export
  - Update 11 source statements to use ISH_PACKAGES_DIR
- [ ] Fix ish package routers (7 files, 9 source statements)
  - kanban.sh, self.sh, utils.sh, utils/tui.sh
  - Remove script_dir computation, use ISH_PACKAGES_DIR
  - Keep {module}_module_dir for intra-package references
- [ ] Fix dotfiles package routers (5 files, 8 source statements)
  - bootstrap.sh, git.sh, nix.sh, bootstrap/posix.sh, bootstrap/kali.sh, bootstrap/macos.sh
  - Remove script_dir computation, use ISH_PACKAGES_DIR
  - Keep {module}_module_dir for intra-package references
- [ ] Handle special cases (kanban and self modules reference repo-level paths)
  - Use ISH_PACKAGES_DIR/.. for repo root references
- [ ] Verify each change incrementally
  - Test after entry point fix: `./ish help`
  - Test after ish routers: `./ish kanban show`, `./ish self test unit`
  - Test after dotfiles routers: `./ish bootstrap posix help`
  - Run full test suite: `./ish self test all` (108 tests)

## deliverable

All 28 source statements updated to use ISH_PACKAGES_DIR. Tests pass. System works with both repo and registry structures.

## pattern

**Before:**
```bash
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." &>/dev/null && pwd -P)
source "${script_dir}/bash/utils/tui.sh"
```

**After (entry point):**
```bash
ISH_PACKAGES_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." &>/dev/null && pwd -P)
export ISH_PACKAGES_DIR
```

**After (all files):**
```bash
source "${ISH_PACKAGES_DIR}/ish/source/utils/tui.sh"
```

## transition to registry (phase 3)

When implementing registry, entry point becomes mode-aware:

```bash
if [[ -f "$(dirname "${BASH_SOURCE[0]}")/../source/platform.sh" ]]; then
  # Development mode
  ISH_PACKAGES_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." &>/dev/null && pwd -P)
else
  # Installed mode
  ISH_PACKAGES_DIR="${HOME}/.local/share/ish/packages"
fi
export ISH_PACKAGES_DIR
```

All package code remains unchanged. Zero refactoring required.

## notes

**Why not other options?**
- Helper function: Premature abstraction (only one repetition)
- Package manifest: Speculative generality (no metadata needed yet)
- Manual path fixes: Creates inconsistent patterns, requires future rework

**Files affected:** 13 total (1 entry point + 12 routers)

**Source statements:** 28 total (11 entry point + 17 routers)

**Critical files:**
- `packages/ish/bin/ish` - Entry point; establishes ISH_PACKAGES_DIR
- `packages/ish/source/kanban.sh` - Uses repo paths (special case)
- `packages/ish/source/self.sh` - Uses test paths (special case)
