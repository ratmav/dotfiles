# extensions

type signatures and behavior for integration modules. extensions wrap external binaries, composing primitives (stream, file, pipe) around shell calls. they're not bash primitives — they depend on something being installed.

## sqlite

wraps `sqlite3` CLI. foreign keys enforced on every connection. callers compose with `&&`.

```bash
# @type: string -> string
# escape single quotes for safe SQL string interpolation (' -> '')
ish_sqlite_escape "it's"   # => it''s

# usage in SQL:
ish_sqlite_exec --db="$db" \
  --sql="INSERT INTO tasks (title) VALUES ('$(ish_sqlite_escape "$title")');"

# @type: --db=string --sql=string -> IO () | error
ish_sqlite_exec --db="$db" --sql="CREATE TABLE items (id TEXT PRIMARY KEY);"

# @type: --db=string --sql=string -> IO [row] | error
# rows are pipe-separated, one per line
ish_sqlite_query --db="$db" --sql="SELECT id, title FROM tasks;"
# => task-one|first task
# => task-two|second task

# @type: --db=string --sql=string -> IO row | error
# fails if zero or more than one row returned
ish_sqlite_query_one --db="$db" --sql="SELECT title FROM tasks WHERE id = 'foo';"

# @type: --db=string -> stdin -> IO () | error
# reads SQL from stdin, wraps in BEGIN/COMMIT, rolls back on failure
ish_sqlite_transaction --db="$db" <<< "INSERT INTO a ...; INSERT INTO b ...;"

# @type: --db=string -> IO () | error
# fails if sqlite3 not on PATH
ish_sqlite_require

# @type: --db=string [--tables=string] -> IO string | error
# data-only INSERTs (no schema), fails if no data
ish_sqlite_dump --db="$db" --tables="tasks"

# @type: --db=string -> stdin -> IO () | error
# pipe dump output into a fresh db
ish_sqlite_dump --db="$src" | ish_sqlite_load --db="$dst"
```

### composition

```bash
# callers chain with &&, each function provides its own error context
ish_sqlite_exec --db="$db" --sql="INSERT INTO tasks ..." \
  && ish_sqlite_exec --db="$db" --sql="UPDATE board ..."

# parse query results with stream_map
ish_sqlite_query --db="$db" --sql="SELECT id, title FROM tasks;" \
  | ish_stream_map extract_title
```

### performance

sqlite3 is fast. the bottleneck is process spawn (~5ms per invocation), not query execution. acceptable for kanban-scale data (10s-100s of rows). use `ish_sqlite_transaction` to batch when it matters.

## see also

- [primitives.md](primitives.md) — foundation and primitive layers
- [layers.md](layers.md) — where extensions sit in the stack
