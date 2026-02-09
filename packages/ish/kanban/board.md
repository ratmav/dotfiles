# ish kanban board

## base case and vision

**Base case:** Local dotfiles management (bootstrap, git, nix, configs)

**Vision:** Functional infrastructure orchestration (see packages/ish/docs/architecture/functional_future/)

**Strategy:**
1. Restructure to package architecture (phase 1)
2. Build FP core (`ish_core_*`) - the magic layer (phase 2)
3. Implement features FP-style using core primitives (phase 3+)
4. Proven patterns extend to homelab/infra packages (future)

**Naming convention:** `ish_core_stream`, `ish_core_validate`, `ish_core_semantic` (not utils - too generic)

## open questions

none - see packages/ish/docs/architecture/task_reconciliation.md for resolved architectural decisions

## milestones

- [ ] **phase 1: restructure** ← current phase
- [ ] phase 2: fp core + cleanup
- [ ] phase 3: core implementation (fp-style)
- [ ] phase 4: remote execution
- [ ] phase 5: enhancements
- [ ] phase 6: split repos

---

## phase 1: restructure

**goal:** align project structure with package architecture

### todo (priority order)

1. [ ] execute migration_path.md Step 1 (12-step restructure)
   - [x] create packages/ish/ and packages/dotfiles/ structure
   - [x] move source files to package locations
   - [x] [fix-module-loading](tasks/fix-module-loading.md) - fix 28 broken source statements with ISH_PACKAGES_DIR
   - [x] [complete-namespace-restructure](tasks/complete-namespace-restructure.md) - remove "self", add "dotfiles" namespace, split tests by package
   - [x] [move-kanban-to-ish](tasks/move-kanban-to-ish.md) - move kanban data to ish package, fix script_dir bug
   - [x] [package-local-bats](tasks/package-local-bats.md) - bats submodules per package, add dotfiles scaffold tests
   - [x] [move-docs-to-ish](tasks/move-docs-to-ish.md) - move docs/ to packages/ish/docs/ (all docs are ish-specific)
2. [ ] [add-run-help-pattern](tasks/add-run-help-pattern.md) - executable leaves use --run/--help flags
3. [ ] run linter pass (flush out issues)
4. [ ] verify tests still pass
5. [ ] verify local package structure works

### in progress

---

## phase 2: fp core + cleanup

**goal:** build functional programming foundation and clean up legacy systems

### todo

**FP Core (The Magic Layer):**
1. [ ] [build-fp-core-stream](tasks/build-fp-core-stream.md) - map, bind, filter, fold primitives
2. [ ] [build-fp-core-validate](tasks/build-fp-core-validate.md) - validators and combinators
3. [ ] [build-fp-core-semantic](tasks/build-fp-core-semantic.md) - semantic wrappers (English-like names)
4. [ ] refactor existing code to use ish_core_* primitives
5. [ ] document FP patterns and usage

**Documentation:**
6. [ ] [setup-mdbook-docs](tasks/setup-mdbook-docs.md) - mdBook + mermaid for package docs

**Cleanup:**
7. [ ] [audit-dead-files](tasks/audit-dead-files.md) - remove legacy bootstrap, dead code
8. [ ] [cleanup-docs](tasks/cleanup-docs.md) - remove home-manager/nix-darwin from systems

**Note:** FP core is the foundation. Build incrementally, test thoroughly. ALL functions use `ish_core_*` prefix to prevent namespace pollution. See packages/ish/docs/architecture/functional_future/ for vision.

---

## phase 3: core implementation (fp-style)

**goal:** implement package system and registry using FP core primitives

### todo

1. [ ] [add-to-path](tasks/add-to-path.md) - verify ish self install implementation (using ish_core_*)
2. [ ] [gpg-signed-commits](tasks/gpg-signed-commits.md) - enable GPG signing
3. [ ] [implement-registry](tasks/implement-registry.md) - registry system (ish/registry module with data/packages/)
4. [ ] implement package commands (migration_path.md Step 3) - using ish_core_*
5. [ ] test locally (migration_path.md Step 4)

**Note:** All new code uses FP core primitives. Keep functions small (≤15 lines), pure where possible, semantic names. Registry data lives in source/registry/data/packages/*.conf, validated with `ish registry validate`.

---

## phase 4: remote execution

**goal:** enable remote execution across hosts

### todo

1. [ ] add remote execution architecture docs
2. [ ] [remote-flag](tasks/remote-flag.md) - implement --remote=host flag
3. [ ] [ssh-features](tasks/ssh-features.md) - ssh key management
4. [ ] [advanced-remote](tasks/advanced-remote.md) - host groups, parallel execution

---

## phase 5: enhancements

**goal:** improve developer experience

### todo

1. [ ] [dependency-tree](tasks/dependency-tree.md) - kanban dependency visualization
2. [ ] [scaffolding](tasks/scaffolding.md) - module scaffolding commands

---

## phase 6: split repos

**goal:** extract ish to separate repo

### todo

1. [ ] [git-default-branch](tasks/git-default-branch.md) - create main branch with GPG signed commit
2. [ ] execute migration_path.md Step 5 (split repos)

---

## notes

**Architecture:**
- packages/ish/docs/architecture/ - current package system architecture
- packages/ish/docs/architecture/functional_future/ - FP vision and patterns
- packages/ish/docs/architecture/task_reconciliation.md - task dispositions and rationale

**Key decisions:**
- Top-down package model (ish loads packages)
- FP core primitives (`ish_core_*`) provide foundation
- Build incrementally: restructure → FP core → implement features → extend
- Base case: local dotfiles management
- Future: homelab/infrastructure orchestration
