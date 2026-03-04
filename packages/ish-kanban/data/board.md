# ish kanban board

## base case and vision

**Base case:** Local dotfiles management (bootstrap, git, nix, configs)

**Vision:** Functional infrastructure orchestration (see core/docs/vision/fp_vision.md)

**Strategy:**
1. Build FP core — primitives and integrations (phase 1)
2. Refactor existing code (ratfiles, etc.) to use FP, cleanup (phase 2)
3. Implement kanban SQLite redesign using FP, delete dead code (phase 3)
4. Proven patterns extend to registry, remote execution, infra packages (future)

**Naming convention:** `ish_stream`, `ish_file`, `ish_sqlite`, `ish_git` (not utils - too generic)

## open questions

none - resolved architectural decisions documented in kanban tasks

---

## phase 1: fp core

**goal:** build functional programming foundation

### todo (priority order)

**Integrations (external binaries composed through primitives):**
1. [ ] [build-fp-core-git](tasks/build-fp-core-git.md) - git operation chains via stream + file + pipe

**FP Layer:**
3. [ ] [build-fp-core-validate](tasks/build-fp-core-validate.md) - validators and combinators
4. [ ] [build-fp-core-semantic](tasks/build-fp-core-semantic.md) - semantic wrappers (English-like names)
5. [ ] [fix-lint-command](tasks/fix-lint-command.md) - simplify to `ish lint`, fix globbing so shellcheck works
6. [ ] document FP patterns and usage

## phase 2: refactor + cleanup

**goal:** refactor existing code to use FP core, clean up legacy

### todo

1. [ ] [namespace-private-functions](tasks/namespace-private-functions.md) - prefix all private `_foo` functions with `_ish_` to prevent global collisions
2. [ ] [refactor-ratfiles-git](tasks/refactor-ratfiles-git.md) - replace raw shell calls with ish atoms in ratfiles git module
3. [ ] [reconcile-task-architecture](tasks/reconcile-task-architecture.md) - document top-down decision in architecture docs
4. [ ] [ishen-dotfiles-package](tasks/ishen-dotfiles-package.md) - restructure dotfiles package
5. [ ] run linter pass (flush out issues) - includes error handling checks: set -eeuo pipefail, ${1-} pattern, tui_error usage, quoted variables
4. [ ] [audit-dead-files](tasks/audit-dead-files.md) - remove legacy bootstrap, dead code
5. [ ] [cleanup-docs](tasks/cleanup-docs.md) - remove home-manager/nix-darwin from systems
6. [ ] [implement-module-namespace-linter](tasks/implement-module-namespace-linter.md) - static analysis for module_dir violations and DAG enforcement
7. [ ] [verify-bash-portability](tasks/verify-bash-portability.md) - version checks, cross-platform testing
8. [ ] verify tests still pass
9. [ ] verify local package structure works

---

## phase 3: kanban redesign

**goal:** implement SQLite-backed kanban using FP core, delete dead code

### todo

1. [ ] [kanban-sqlite-redesign](tasks/kanban-sqlite-redesign.md) - replace markdown board + task files with SQLite, migrations, and active record models
2. [ ] [dependency-tree](tasks/dependency-tree.md) - DAG query commands (`deps`, `next`, `blocked`)
3. [ ] [kanban-task-validation](tasks/kanban-task-validation.md) - add validation functions
4. [ ] [kanban-task-close](tasks/kanban-task-close.md) - replace delete with close command
5. [ ] [kanban-integration-testing](tasks/kanban-integration-testing.md) - complete integration test coverage
6. [ ] [kanban-task-list-filters](tasks/kanban-task-list-filters.md) - enhance task listing with filters
7. [ ] [kanban-data-submodule](tasks/kanban-data-submodule.md) - extract kanban data to git submodule
8. [ ] delete dead kanban code (old markdown parsing, task files)

---

## phase 4: core implementation (fp-style)

**goal:** implement package system and registry using FP core primitives

### todo

1. [ ] [add-to-path](tasks/add-to-path.md) - add ish to PATH, implement tab completion
2. [ ] [gpg-signed-commits](tasks/gpg-signed-commits.md) - enable GPG signing
3. [ ] [implement-registry](tasks/implement-registry.md) - registry system (ish/registry module with data/packages/)
4. [ ] [project-ishrc](tasks/project-ishrc.md) - per-project hot package loading via .ishrc in cwd

---

## phase 5: remote execution

**goal:** enable remote execution across hosts

### todo

**Integrations (external binaries composed through primitives):**
1. [ ] [build-fp-integration-curl](tasks/build-fp-integration-curl.md) - HTTP operations via curl
2. [ ] [build-fp-integration-ssh](tasks/build-fp-integration-ssh.md) - remote execution via ssh
3. [ ] [build-fp-integration-jq](tasks/build-fp-integration-jq.md) - JSON parsing via jq

**Remote execution features:**
4. [ ] add remote execution architecture docs
5. [ ] [remote-flag](tasks/remote-flag.md) - implement --remote=host flag
6. [ ] [ssh-features](tasks/ssh-features.md) - ssh key management
7. [ ] [advanced-remote](tasks/advanced-remote.md) - host groups, parallel execution

---

## phase 6: enhancements

**goal:** improve developer experience

### todo

1. [ ] [scaffolding](tasks/scaffolding.md) - module scaffolding commands
2. [ ] [setup-mdbook-docs](tasks/setup-mdbook-docs.md) - mdBook + mermaid for package docs

---

## phase 7: split repos

**goal:** extract ish to separate repo

### todo

1. [ ] [git-default-branch](tasks/git-default-branch.md) - create main branch with GPG signed commit
2. [ ] extract `core/` to separate `ish` repo, `packages/ish-ratfiles/` stays in dotfiles repo
3. [ ] [core-semantic-versioning](tasks/core-semantic-versioning.md) - semver tags for ish core, package version pinning, install/test/lint validation

---

## notes

**Architecture:**
- core/docs/architecture/ - current package system architecture
- core/docs/architecture/ - current architecture (layers, primitives, monads)
- core/docs/vision/fp_vision.md - FP vision and patterns
- packages/ish-kanban/data/tasks/reconcile-task-architecture.md - top-down decision and rationale

**Key decisions:**
- Top-down package model (ish loads packages)
- FP core: foundation (color, file_descriptor, exists) → primitives (stream, file, pipe) → integrations (sqlite, git in phase 1; curl, ssh, jq in phase 5) → layer (validate, semantic)
- Integrations are built when their first consumer exists (sqlite/git for kanban, curl/ssh/jq for remote exec)
- Bind lives at the primitive layer only (stream_bind) — iterates dynamic stdin data with short-circuit. Integrations (git, sqlite) use `&&` for known step sequences. See core/docs/architecture/monads.md
- Build FP first, refactor existing code, then tackle kanban redesign with proven tools
- Base case: local dotfiles management
- Future: homelab/infrastructure orchestration
