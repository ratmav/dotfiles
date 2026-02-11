# Task Reconciliation

This document maps existing kanban tasks to the current architecture, documenting which tasks are obsolete, deferred, or integrated into the migration path.

## Architectural Decision: Top-Down Model

**Decision:** ish uses a **top-down architecture** where ish orchestrates and packages extend it.

**Rationale:**
- ish is the orchestrator, packages plug into ish
- Even ish core itself is a package in the final vision
- Less complex than bottom-up (projects importing framework)
- ish's conventions (naming, routing, structure) are opinionated - users accept ish's way or don't use ish
- Simpler model that scales better

**Rejected:** Bottom-up framework/project split where projects import ish-framework as a library. This would require users to adopt all conventions and is more complex.

**Implications:**
- Current architecture docs (package system) are correct
- Tasks referencing "framework/project split" are obsolete
- Dependency direction: `ish → packages` (not `projects → framework`)

---

## Task Dispositions

### Obsolete Tasks

These tasks described a bottom-up framework/project architecture that conflicts with the top-down package system.

**Tasks to remove:**
- `design-split.md` - Described three-layer framework/project/config split
- `implement-split.md` - Implementation of framework split
- `battle-test-runner.md` - Identifying framework vs project boundaries
- `migrate-projects.md` - Migrating projects to ish-framework

**Why obsolete:** Current architecture handles the split via packages (ish package + dotfiles package). The migration path (migration_path.md) already describes restructuring the monolith into package structure.

---

### Deferred Tasks

These tasks are valuable but should wait until after core architecture is stable.

#### Remote Execution (Deferred until after restructure)

**Tasks:**
- `remote-flag.md` - Basic `--remote=host` implementation
- `advanced-remote.md` - Host groups, parallel execution, inventory
- `ssh-features.md` - SSH key management (dependency for remote)

**Status:** Remote execution IS a core feature (ssh/scp wrapper for running ish on remote hosts).

**Deferral reason:** Avoid reworking remote features during restructure. Implement AFTER migration_path.md Step 1 (restructure) is complete.

**Architecture needed:** Add remote execution to architecture docs (currently missing).

#### Enhancements (Deferred until structure stabilizes)

**Tasks:**
- `dependency-tree.md` - Kanban dependency visualization (`ish kanban deps/next/blocked`)
- `scaffolding.md` - Module scaffolding (`ish new foo/bar/baz`)

**Deferral reason:** Want to see package structure working locally before adding enhancements. These are useful but not critical path.

---

### Integrated Tasks

These tasks are already part of the current architecture or align with the migration path.

**Task:** `add-to-path.md` (ish install command)
- **Status:** Already in architecture as `ish self install` (registry_commands.md)
- **Disposition:** Verify implementation aligns with arch docs

**Task:** `gpg-signed-commits.md` (Enable GPG signing)
- **Status:** Already in migration_path.md Step 2
- **Disposition:** Execute as documented

**Task:** `package-system.md` (Package registry)
- **Status:** This IS the current architecture (core_concepts_and_data_structures.md, registry_commands.md)
- **Disposition:** Implement per migration path

---

### Cleanup Tasks

These tasks should execute AFTER restructure but BEFORE new features.

**Tasks:**
- `audit-dead-files.md` - Remove legacy bootstrap, dead code
- `cleanup-docs.md` - Remove home-manager/nix-darwin from systems

**Priority:** After migration_path.md Step 1 (restructure), before adding new features.

**Reasoning:** Clean up hosts running old nix setup (kali, macos) before proceeding. Get rid of dead code after structure is stable.

---

### Git Strategy Tasks

**Task:** `git-default-branch.md` (Set default branch to main)
- **Disposition:** Handle during repo split, not before
- **Strategy:**
  - Keep current history on `master` (10+ years, unsigned, historical/nostalgia)
  - Create `main` branch from current state
  - First commit on `main`: dotfiles as ish package structure (GPG signed)
  - Delete or archive `master` after split

**Task:** `repo-reboot.md` (Squash history, clean slate)
- **Disposition:** Not needed - preserve history on `master`, start fresh on `main`

---

## Priority Order

Based on architectural alignment:

### Phase 1: Restructure (Current)
1. Execute migration_path.md Step 1 (12-step restructure)
2. Run linter pass (flush out issues)
3. Verify tests still pass
4. Verify local package structure works

### Phase 2: Cleanup
1. `audit-dead-files.md` - Remove dead code
2. `cleanup-docs.md` - Remove home-manager/nix-darwin from systems

### Phase 3: Core Implementation
1. Implement `ish self install` (verify against add-to-path.md)
2. Implement GPG signing (migration_path.md Step 2)
3. Implement registry commands (migration_path.md Step 3)
4. Test locally (migration_path.md Step 4)

### Phase 4: Remote Execution
1. Add remote execution to architecture docs
2. Implement `--remote=host` flag (remote-flag.md)
3. Implement SSH key management (ssh-features.md)
4. Implement advanced remote features (advanced-remote.md)

### Phase 5: Enhancements
1. Dependency tree visualization (dependency-tree.md)
2. Module scaffolding (scaffolding.md)

### Phase 6: Split Repos
1. Create `main` branch with GPG signed commit
2. Execute migration_path.md Step 5 (split repos)

---

## Open Tasks Review

### Keep (Aligned with Architecture)
- `gpg-signed-commits.md` ✓
- `add-to-path.md` ✓ (verify as `ish self install`)
- `package-system.md` ✓ (this is the architecture)

### Keep (Deferred)
- `remote-flag.md` - Phase 4
- `advanced-remote.md` - Phase 4
- `ssh-features.md` - Phase 4
- `dependency-tree.md` - Phase 5
- `scaffolding.md` - Phase 5

### Keep (Cleanup)
- `audit-dead-files.md` - Phase 2
- `cleanup-docs.md` - Phase 2

### Keep (Git Strategy)
- `git-default-branch.md` - Phase 6

### Remove (Obsolete)
- `design-split.md` ✗
- `implement-split.md` ✗
- `battle-test-runner.md` ✗
- `migrate-projects.md` ✗
- `repo-reboot.md` ✗ (strategy changed)

---

## Next Steps

1. Remove obsolete tasks from kanban/
2. Update board.md to reflect new priorities
3. Execute migration_path.md Step 1 (restructure)
4. Proceed with Phase 1 implementation
