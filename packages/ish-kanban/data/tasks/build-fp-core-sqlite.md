# build ish_sqlite - functional sqlite operations

**dependencies:** build-fp-core-stream, build-fp-core-file, build-fp-core-pipe

**priority:** high

## description

Build functional sqlite integration that composes core stream and file primitives around shell calls to `sqlite3`. Not a bash primitive — this is a composition layer over an external binary. Query results flow through stream, migration files flow through file.

The kanban models own the SQL (what to query). This module owns the execution (how to run it). Each function provides its own error context. Callers compose with `&&`.

## subtasks

- [ ] implement `ish_sqlite_exec` - execute statement, no result (INSERT/UPDATE/DELETE/DDL)
- [ ] implement `ish_sqlite_query` - execute query, stream results to stdout (SELECT)
- [ ] implement `ish_sqlite_query_one` - execute query, return single row or fail
- [ ] implement `ish_sqlite_transaction` - wrap operations in BEGIN/COMMIT, ROLLBACK on failure
- [ ] implement `ish_sqlite_require` - assert sqlite3 exists or fail with message
- [ ] implement `ish_sqlite_dump` - export data INSERTs to stdout (no schema)
- [ ] implement `ish_sqlite_load` - import SQL from stdin
- [ ] write unit tests for each function
- [ ] document with type signatures and examples

## deliverable

`core/source/sqlite.sh` with tested functions

## notes

**Concrete patterns from kanban to extract:**
- model CRUD wrappers: each model function calls sqlite3 with SQL, checks exit code, handles errors
- migration runner: execute each `.sql` file in order inside a transaction
- data export: `sqlite3 kanban.db .dump` filtered to data-only INSERTs
- data import: `sqlite3 kanban.db < kanban.sql`
- single-row queries: `task show --id foo` expects exactly one result

**Type signatures:**
```bash
# @type: dbpath -> sql -> IO () | error
ish_sqlite_exec()

# @type: dbpath -> sql -> IO [row] | error
ish_sqlite_query()

# @type: dbpath -> sql -> IO row | error
ish_sqlite_query_one()

# @type: dbpath -> IO () -> IO () | error (ROLLBACK)
ish_sqlite_transaction()

# @type: dbpath -> IO () | error
ish_sqlite_require()

# @type: dbpath -> [table] -> IO string | error
ish_sqlite_dump()

# @type: dbpath -> stdin -> IO () | error
ish_sqlite_load()
```

**Callers compose with `&&`:**
```bash
ish_sqlite_exec "$db" "INSERT INTO tasks ..." \
    && ish_sqlite_exec "$db" "UPDATE board ..."
```

Each function provides actionable error context on failure. No bind wrapper needed — `&&` already short-circuits, and error context belongs in the individual functions, not in a generic chaining mechanism.

**Result format.** sqlite3 outputs pipe-separated by default. use `-separator` flag for consistency. callers parse results via stream_map. keep the output format simple and predictable — one row per line, fields separated by a known delimiter.

**Foreign keys must be enabled.** sqlite3 does not enforce foreign keys by default. every connection must run `PRAGMA foreign_keys = ON;` before any operations. `ish_sqlite_exec` and `ish_sqlite_query` handle this internally — callers never think about it.

**Performance characteristics:**

sqlite3 is fast. the bottleneck is process spawn (one sqlite3 invocation per query), not query execution.

- Process spawn cost: ~5ms per sqlite3 invocation
- Query execution: near-instant for small datasets (< 10,000 rows)
- Transaction batching: amortizes spawn cost across multiple statements
- Acceptable for: kanban-scale data (10s-100s of tasks)
- If performance matters: batch statements in a single sqlite3 invocation via heredoc

**Mitigation strategies:**
- Transaction wrapper batches multiple operations into one sqlite3 call
- Target use case: small datasets (task boards, config registries)
- Document performance in function comments

**Testing:**
- [ ] Unit tests for correctness (exec/query/query_one/transaction)
- [ ] Test transaction rollback on failure
- [ ] Test foreign key enforcement (ON DELETE CASCADE)
- [ ] Test with empty db, missing db, corrupt db
