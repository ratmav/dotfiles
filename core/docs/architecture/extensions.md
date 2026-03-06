# extensions

type signatures and behavior for integration modules. extensions wrap external binaries, composing primitives (stream, file, pipe) around shell calls. they're not bash primitives — they depend on something being installed.

## sqlite3

wraps `sqlite3` CLI. foreign keys enforced on every connection. callers compose with `&&`.

### parameterized queries

values are bound via native sqlite3 `?` parameter binding. positional args after named options become bound parameters. this prevents SQL injection at the engine level — values never touch the SQL parser.

```bash
# @type: --db=string --sql=string [--separator=string] [params...] -> IO [row] | error
# execute SQL with native parameter binding
ish_sqlite3_exec --db="$db" --sql="INSERT INTO tasks (title) VALUES (?);" "$title"

# read with pipe-separated columns
ish_sqlite3_exec --db="$db" --sql="SELECT id, title FROM tasks WHERE status = ?;" --separator='|' "$status"
# => task-one|first task
# => task-two|second task

# multiple params bind to ?1, ?2, etc. in order
ish_sqlite3_exec --db="$db" \
  --sql="INSERT INTO tasks (title, status) VALUES (?, ?);" \
  "$title" "$status"
```

### threat model

parameter binding protects **values** — the common injection vector. a caller cannot accidentally interpolate `'; DROP TABLE tasks;--` into a bound parameter.

parameter binding cannot protect the **query structure** (`--sql=` string itself). if a caller builds `--sql=` from untrusted input without using `?` placeholders, binding can't help. this is true in every language — you can't parameterize the query structure itself. the `--sql=` argument is the query template, owned by the caller.

### other operations

```bash
# @type: string -> string
# escape single quotes for SQL identifiers (' -> '')
# use for table/column names only — use ? params for values
ish_sqlite3_escape "it's"   # => it''s

# @type: --db=string --sql=string [params...] -> IO row | error
# fails if zero or more than one row returned
ish_sqlite3_query_one --db="$db" --sql="SELECT title FROM tasks WHERE id = ?;" "$id"

# @type: --db=string [params...] -> stdin -> IO () | error
# reads SQL from stdin, wraps in BEGIN/COMMIT, rolls back on failure
ish_sqlite3_transaction --db="$db" "$title" "$status" \
  <<< "INSERT INTO tasks (title, status) VALUES (?, ?);"

# @type: --db=string -> IO () | error
# fails if sqlite3 not on PATH
ish_sqlite3_require

# @type: --db=string [--tables=string] -> IO string | error
# data-only INSERTs (no schema), fails if no data
ish_sqlite3_dump --db="$db" --tables="tasks"

# @type: --db=string -> stdin -> IO () | error
# pipe dump output into a fresh db
ish_sqlite3_dump --db="$src" | ish_sqlite3_load --db="$dst"

# @type: [params...] -> stdout
# build .parameter set lines for native binding (used internally by exec/transaction)
ish_sqlite3_build_params_stdin "$val1" "$val2"
```

### composition

```bash
# callers chain with &&, each function provides its own error context
ish_sqlite3_exec --db="$db" --sql="INSERT INTO tasks (title) VALUES (?);" "$title" \
  && ish_sqlite3_exec --db="$db" --sql="UPDATE board SET updated = 1;"

# parse query results with stream_map
ish_sqlite3_exec --db="$db" --sql="SELECT id, title FROM tasks;" --separator='|' \
  | ish_stream_map extract_title
```

### performance

sqlite3 is fast. the bottleneck is process spawn (~5ms per invocation), not query execution. acceptable for kanban-scale data (10s-100s of rows). use `ish_sqlite3_transaction` to batch when it matters.

## see also

- [primitives.md](primitives.md) — foundation and primitive layers
- [layers.md](layers.md) — where extensions sit in the stack
