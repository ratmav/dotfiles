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

## queries

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

see [data_infrastructure.md](data_infrastructure.md) for storage, migrations, and models.
