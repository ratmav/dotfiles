# ish kanban board

## open questions

none - see docs/architecture/task_reconciliation.md for resolved architectural decisions

## milestones

- [ ] **phase 1: restructure** ← current phase
- [ ] phase 2: cleanup
- [ ] phase 3: core implementation
- [ ] phase 4: remote execution
- [ ] phase 5: enhancements
- [ ] phase 6: split repos

---

## phase 1: restructure

**goal:** align project structure with package architecture

### todo (priority order)

1. [ ] execute migration_path.md Step 1 (12-step restructure)
   - create packages/ish/ and packages/dotfiles/ structure
   - move source files to package locations
   - split tests and docs by package
   - add namespace prefixes (ish_*, dotfiles_*)
2. [ ] run linter pass (flush out issues)
3. [ ] verify tests still pass
4. [ ] verify local package structure works

### in progress

---

## phase 2: cleanup

**goal:** clean up dead code and legacy systems

### todo

1. [ ] [audit-dead-files](tasks/audit-dead-files.md) - remove legacy bootstrap, dead code
2. [ ] [cleanup-docs](tasks/cleanup-docs.md) - remove home-manager/nix-darwin from systems

---

## phase 3: core implementation

**goal:** implement package system and registry

### todo

1. [ ] [add-to-path](tasks/add-to-path.md) - verify ish self install implementation
2. [ ] [gpg-signed-commits](tasks/gpg-signed-commits.md) - enable GPG signing
3. [ ] implement registry commands (migration_path.md Step 3)
4. [ ] test locally (migration_path.md Step 4)

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

see docs/architecture/task_reconciliation.md for:
- obsolete tasks removed
- architectural decisions (top-down package model)
- task priority rationale
