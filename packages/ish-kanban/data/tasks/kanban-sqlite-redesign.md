# kanban-sqlite-redesign

**dependencies:** none

**priority:** task zero — do this first

## description

Replace the markdown board + task files with a SQLite-backed data model. The board becomes a rendered view, not a data store.

## architecture

### data model

Three tables: `tasks`, `dependencies`, `migrations`. See `packages/ish-kanban/docs/data_model.md` for full schema, design decisions, and queries.

Key points:
- No status column — open vs blocked is computed from the dependency graph
- Done tasks are deleted — git log is the historical record
- Title is UNIQUE, slug (id) is derived from title
- ON DELETE CASCADE cleans up dependency edges

### migrations (auto-check, no CLI command)

no explicit migrate command. every `ish kanban` invocation quietly checks that all migrations have been applied before routing. if unapplied migrations exist, the user is prompted to apply them. this guarantees the database structure always matches what the code expects.

```
source/migrations/
  20260217000000_create_tasks.sql
  20260217000001_create_dependencies.sql
```

### models (active record pattern)

Query wrappers in `source/models/`. All raw SQL stays in the model layer — callers never write SQL directly.

```
source/models/
  task.sh          -- ish_kanban_model_task_create, _show, _list, _edit, _delete, _ready, _blocked
  dependency.sh    -- ish_kanban_model_dependency_link, _unlink, _list
```

### cli

All flags are explicit (`--title`, `--id`, `--body`, `--depends-on`). Body accepts stdin when piped. No `$EDITOR` invocation. See `packages/ish-kanban/docs/cli_workflow.md`.

### vim integration

Native vim works now via `:w !` and `:r !`. Future `:Ish` neovim plugin modeled after fugitive, using epoch as starting point. See `packages/ish-kanban/docs/vim_integration.md`.

## tasks this replaces

The following existing tasks are eliminated — SQLite provides what they were going to build out of markdown parsing:

- kanban-board-parser
- kanban-board-mutations
- kanban-source-board-module
- kanban-task-create-integration

## fp layering (future: phase 2)

sqlite query execution, file handling, and stream handling are the first FP extraction targets for `ish_*`. kanban models are the proving ground — build concrete first, extract generic primitives when patterns repeat. see `packages/ish-kanban/docs/data_model.md` for details.

## data portability

`kanban.db` is a runtime cache, `.gitignore`'d. `kanban.sql` (data INSERTs only, no schema) is the committed text artifact. after any write operation, ish re-exports `kanban.sql`. when db is missing, ish rebuilds from migrations + `kanban.sql`.

every write operation exports `kanban.sql`, then commits and pushes in the data submodule. if any step fails (conflict, no remote, network), error and tell the user to resolve manually. kanban has hard dependencies on `sqlite3` and `git`.

data dir becomes a submodule (see kanban-data-submodule task). conflicts in `kanban.sql` are resolved manually by the user.

## deliverable

- `source/migrations/` — timestamped SQL migration files
- auto-migration check on every `ish kanban` entry (no CLI migrate command)
- auto-export to `kanban.sql` after write operations
- auto-import from `kanban.sql` when db is missing
- `source/models/task.sh` — active record CRUD for tasks table
- `source/models/dependency.sh` — active record CRUD for dependencies table
- Updated CLI using model layer for all task/board operations
- Existing tasks migrated from markdown files to database
- Unit and integration tests
