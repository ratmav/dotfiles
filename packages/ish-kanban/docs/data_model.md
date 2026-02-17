# kanban data model

## overview

SQLite database (`kanban.db`) replaces the markdown board file and task markdown files as the single source of truth. The board becomes a rendered view, not a data store.

`sqlite3` ships with macOS and Kali Linux — it's already on the land.

## schema

```sql
CREATE TABLE tasks (
    id      TEXT PRIMARY KEY,          -- slug derived from title
    title   TEXT NOT NULL UNIQUE,      -- human-readable, must be unique
    body    TEXT,                      -- design details, specs
    created TEXT NOT NULL              -- ISO 8601
);

CREATE TABLE dependencies (
    task_id    TEXT NOT NULL,   -- this task...
    depends_on TEXT NOT NULL,   -- ...depends on this task
    PRIMARY KEY (task_id, depends_on),
    FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE,
    FOREIGN KEY (depends_on) REFERENCES tasks(id) ON DELETE CASCADE
);

CREATE TABLE migrations (
    filename TEXT PRIMARY KEY,  -- e.g. "20260217000000_create_tasks.sql"
    applied  TEXT NOT NULL      -- ISO 8601
);
```

## design decisions

**three tables.** tasks, dependencies, and migrations. the first two are the domain. the third is infrastructure — tracks which schema migrations have been applied.

**title is UNIQUE.** if two tasks have the same name, they're the same task. this also guarantees slug uniqueness since slugs are derived from titles.

**no milestones table.** milestones implied artificial ordering. with dependencies, execution order emerges from the graph. a task that depends on nothing is ready now. a task that depends on three others waits. phases are an illusion — the DAG is the truth.

**no tags/labels table.** task grouping is already encoded in the naming convention. `kanban-board-parser` is clearly kanban work. `build-fp-core-stream` is clearly FP work. the names carry the semantics. add a tags table when we have 2+ real use cases that naming can't handle.

**slug as primary key.** human-readable, greppable, no auto-increment integers to remember. slugs already exist in the current task file names — zero migration friction.

**body as TEXT column.** task specs live in the database, not in separate files. `ish kanban task edit <id>` extracts the body for editing and writes it back. one source of truth, not two.

**no status column.** open vs blocked is computed from the dependency graph, not stored. a task with no dependencies (or all dependencies deleted) is open. a task with existing dependencies is blocked. done = deleted from the database. git log is the historical record.

**ON DELETE CASCADE on dependencies.** deleting a task cleans up its dependency edges. no orphaned references. closing a dependency automatically unblocks downstream tasks.

**ISO 8601 timestamps.** `date -u +%Y-%m-%dT%H:%M:%SZ` — sortable, unambiguous, UTC.

## queries that matter

```sql
-- open tasks (no dependencies in the table)
SELECT t.id, t.title FROM tasks t
WHERE NOT EXISTS (
    SELECT 1 FROM dependencies d
    WHERE d.task_id = t.id
);

-- blocked tasks (has dependencies in the table)
SELECT t.id, t.title FROM tasks t
WHERE EXISTS (
    SELECT 1 FROM dependencies d
    WHERE d.task_id = t.id
);

-- what blocks a specific task
SELECT blocker.id, blocker.title
FROM dependencies d
JOIN tasks blocker ON d.depends_on = blocker.id
WHERE d.task_id = ?;

-- what does a specific task unblock
SELECT downstream.id, downstream.title
FROM dependencies d
JOIN tasks downstream ON d.task_id = downstream.id
WHERE d.depends_on = ?;
```

## data location

`packages/ish-kanban/data/` is a git submodule (separate repo). contains:

```
data/
  kanban.sql    ← committed, text, mergeable — data INSERTs only (no schema)
  kanban.db     ← .gitignore'd, runtime cache rebuilt from migrations + kanban.sql
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

## fp layering (future: phase 2)

the sqlite operations in kanban are a prime candidate for generic FP primitives in `ish_*`. the split:

**generic (`ish_*`):** three layers emerging from kanban:

- **foundation**: file_descriptor — the POSIX I/O primitive everything stands on
- **primitives** (built on file descriptors): stream (data flowing through pipes — map/bind/filter/fold), file (buckets — persistent I/O endpoints), pipe (process composition — connecting commands)
- **integrations** (external binaries composed through primitives): sqlite and git. shell calls whose results flow through stream, file, and pipe primitives.

all follow the same pattern — chained operations that short-circuit on failure. integrations depend on primitives, primitives depend on file_descriptor.

**kanban-specific (`ish_kanban_model_*`):** thin wrappers that define the SQL and call the generic layer. the kanban models own the data model (what to query), the core owns the execution model (how to run it).

this separation means other packages can use sqlite without reinventing query execution. the kanban package is the proving ground — build it concrete first, extract the generic layer when we see the patterns repeat.

**the write path is a monad.** export → commit → push is a chain where each step depends on the prior succeeding, and any failure short-circuits with an error context. this is `bind` — a prime candidate for `ish_stream` once the FP layer exists. build it imperative first (sequential `&&` checks), extract to monadic composition in phase 2.
