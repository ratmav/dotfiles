# kanban data infrastructure

## data location

`packages/ish-kanban/data/` is a git submodule (separate repo). contains:

```
data/
  kanban.sql    <- committed, text, mergeable — data INSERTs only (no schema)
  kanban.db     <- .gitignore'd, runtime cache rebuilt from migrations + kanban.sql
```

**kanban.sql is the portable artifact.** one INSERT per task, one INSERT per dependency edge. text diffs show exactly what changed. git merges across machines.

**kanban.db is ephemeral.** rebuilt from migrations (schema) + kanban.sql (data) whenever it's missing or stale. never committed.

**writes auto-commit and push.** every mutation exports `kanban.sql`, commits, and pushes in the data submodule. if anything fails (conflict, no remote, network), ish errors and tells the user to resolve manually. reads pull on entry to stay current.

**conflicts are manual.** they're text merge conflicts in `kanban.sql` — resolve in your editor like any other file.

replaces:
- `packages/ish-kanban/data/board.md`
- `packages/ish-kanban/data/tasks/*.md`

## migrations

no explicit migrate command. every `ish kanban` invocation quietly checks that all migrations have been applied before routing. if unapplied migrations exist, the user is prompted to apply them. this guarantees the database structure always matches what the code expects.

**migration files** live in `packages/ish-kanban/source/migrations/` as timestamped SQL files:

```
source/migrations/
  20260217000000_create_tasks.sql
  20260217000001_create_dependencies.sql
```

**auto-check** (runs on every `ish kanban` entry):
1. creates migrations table if it doesn't exist
2. applies any pending migrations (schema)
3. if `kanban.sql` exists and db is empty, imports it (data)
4. if no `kanban.sql`, does nothing — db starts empty
5. routes the command

**on write** (after any mutation — create, edit, delete, link, unlink):
1. re-export `kanban.sql`
2. `git add kanban.sql && git commit && git push` in the data submodule
3. if any step fails (conflict, no remote, network), error and tell the user to resolve manually

**hard dependencies:** kanban requires both `sqlite3` and `git`. check for both on entry.

**initial data migration:** a one-time script reads existing task markdown files, INSERTs into the database, exports to `kanban.sql`, then old files and board.md are deleted manually.

## models (active record pattern)

query wrappers live in `packages/ish-kanban/source/models/`:

```
source/models/
  task.sh          -- ish_kanban_model_task_*
  dependency.sh    -- ish_kanban_model_dependency_*
```

each model file defines bash functions that wrap CRUD operations on the corresponding table. all raw SQL stays in the model layer — callers never write SQL directly.

## fp layering

the sqlite operations in kanban are a prime candidate for generic FP primitives in `ish_*`. the split:

**generic (`ish_*`):** three layers emerging from kanban:

- **foundation**: file_descriptor — the POSIX I/O primitive everything stands on
- **primitives** (built on file descriptors): stream, file, pipe
- **integrations** (external binaries composed through primitives): sqlite and git

all follow the same pattern — chained operations that short-circuit on failure. integrations depend on primitives, primitives depend on file_descriptor.

**kanban-specific (`ish_kanban_model_*`):** thin wrappers that define the SQL and call the generic layer. the kanban models own the data model (what to query), the core owns the execution model (how to run it).

**the write path is a monad.** export -> commit -> push is a chain where each step depends on the prior succeeding. this is `bind`. build it imperative first (`&&` checks), extract to monadic composition when FP core is ready.
