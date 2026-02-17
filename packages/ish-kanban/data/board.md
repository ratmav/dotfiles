# ish kanban board

## base case and vision

**Base case:** Local dotfiles management (bootstrap, git, nix, configs)

**Vision:** Functional infrastructure orchestration (see packages/ish/docs/architecture/functional_future/)

**Strategy:**
1. Build FP core — primitives and integrations (phase 1)
2. Refactor existing code (ratfiles, etc.) to use FP, cleanup (phase 2)
3. Implement kanban SQLite redesign using FP, delete dead code (phase 3)
4. Proven patterns extend to registry, remote execution, infra packages (future)

**Naming convention:** `ish_stream`, `ish_file`, `ish_sqlite`, `ish_git` (not utils - too generic)

## open questions

none - see packages/ish/docs/architecture/task_reconciliation.md for resolved architectural decisions

---

## phase 1: fp core

**goal:** build functional programming foundation

### todo (priority order)

**Doc audit:**
1. [ ] [complete-doc-audit](tasks/complete-doc-audit.md) - finish cleaning stale naming, paths, and examples across all docs and tasks

**Foundation:**
2. [ ] build-fp-core-exists - `ish_exists_executable` at `core/source/exists.sh` (wraps `type`). Environment introspection alongside color + file_descriptor. Migrate 20+ consumers from `ish_utils_exists_executable`.

**Primitives (built on file descriptors):**
3. [ ] [build-fp-core-stream](tasks/build-fp-core-stream.md) - map, bind, filter, fold over stdin/stdout/stderr. Migrate 20+ consumers from `ish_utils_stream_*` → `ish_stream_*`. Delete `source/utils/stream.sh`.
4. [ ] [build-fp-core-file](tasks/build-fp-core-file.md) - read, write, exists (buckets — persistent I/O endpoints). `ish_utils_exists_file` → `ish_file_exists`.
5. [ ] [build-fp-core-pipe](tasks/build-fp-core-pipe.md) - process composition, PIPESTATUS, error-aware chaining

**Utils removal:**
6. [ ] delete `source/utils/` directory and `utils.sh` — empty after exists, stream, and file migrations complete

**Integrations (external binaries composed through primitives):**
7. [ ] [build-fp-core-sqlite](tasks/build-fp-core-sqlite.md) - sqlite3 query execution via stream + file + pipe
8. [ ] [build-fp-core-git](tasks/build-fp-core-git.md) - git operation chains via stream + file + pipe

**FP Layer:**
9. [ ] [build-fp-core-validate](tasks/build-fp-core-validate.md) - validators and combinators
10. [ ] [build-fp-core-semantic](tasks/build-fp-core-semantic.md) - semantic wrappers (English-like names)
11. [ ] [fix-lint-command](tasks/fix-lint-command.md) - simplify to `ish lint`, fix globbing so shellcheck works
12. [ ] document FP patterns and usage

### in progress

---

## phase 2: refactor + cleanup

**goal:** refactor existing code to use FP core, clean up legacy

### todo

1. [ ] [ishen-dotfiles-package](tasks/ishen-dotfiles-package.md) - restructure dotfiles package
2. [ ] refactor ratfiles to use ish_* primitives
3. [ ] run linter pass (flush out issues) - includes error handling checks: set -eeuo pipefail, ${1-} pattern, tui_error usage, quoted variables
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
2. [ ] [kanban-task-validation](tasks/kanban-task-validation.md) - add validation functions
3. [ ] [kanban-task-close](tasks/kanban-task-close.md) - replace delete with close command
4. [ ] [kanban-integration-testing](tasks/kanban-integration-testing.md) - complete integration test coverage
5. [ ] [kanban-task-list-filters](tasks/kanban-task-list-filters.md) - enhance task listing with filters
6. [ ] [kanban-data-submodule](tasks/kanban-data-submodule.md) - extract kanban data to git submodule
7. [ ] delete dead kanban code (old markdown parsing, task files)

---

## phase 4: core implementation (fp-style)

**goal:** implement package system and registry using FP core primitives

### todo

1. [ ] [add-to-path](tasks/add-to-path.md) - verify ish self install implementation (using ish_*)
2. [ ] [gpg-signed-commits](tasks/gpg-signed-commits.md) - enable GPG signing
3. [ ] [implement-registry](tasks/implement-registry.md) - registry system (ish/registry module with data/packages/)
4. [ ] implement package commands (migration_path.md Step 3) - using ish_*
5. [ ] [project-ishrc](tasks/project-ishrc.md) - per-project hot package loading via .ishrc in cwd
6. [ ] test locally (migration_path.md Step 4)

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

1. [ ] [dependency-tree](tasks/dependency-tree.md) - kanban dependency visualization
2. [ ] [scaffolding](tasks/scaffolding.md) - module scaffolding commands
3. [ ] [setup-mdbook-docs](tasks/setup-mdbook-docs.md) - mdBook + mermaid for package docs

---

## phase 7: split repos

**goal:** extract ish to separate repo

### todo

1. [ ] [git-default-branch](tasks/git-default-branch.md) - create main branch with GPG signed commit
2. [ ] execute migration_path.md Step 5 (split repos)
3. [ ] [core-semantic-versioning](tasks/core-semantic-versioning.md) - semver tags for ish core, package version pinning, install/test/lint validation

---

## notes

**Architecture:**
- packages/ish/docs/architecture/ - current package system architecture
- packages/ish/docs/architecture/functional_future/ - FP vision and patterns
- packages/ish/docs/architecture/task_reconciliation.md - task dispositions and rationale

**Key decisions:**
- Top-down package model (ish loads packages)
- FP core: foundation (color, file_descriptor, exists) → primitives (stream, file, pipe) → integrations (sqlite, git in phase 1; curl, ssh, jq in phase 5) → layer (validate, semantic)
- Integrations are built when their first consumer exists (sqlite/git for kanban, curl/ssh/jq for remote exec)
- Monads: every `*_bind` function is the monadic operation — see core/docs/architecture/functional_future/monads.md
- Build FP first, refactor existing code, then tackle kanban redesign with proven tools
- Base case: local dotfiles management
- Future: homelab/infrastructure orchestration
