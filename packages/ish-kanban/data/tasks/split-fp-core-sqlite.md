# sqlite integration cleanup

**dependencies:** extract-extensions-directory

**priority:** high

## subtasks

- [ ] add escaping to exec, query, transaction, dump, load — `ish_sqlite_escape` exists but is never called internally. design decision needed: where does escaping belong?
- [ ] DRY: exec and query are structurally identical except for `-separator '|'`. consider a shared internal function.

## deliverable

`extensions/source/sqlite/` operations with escaping and reduced duplication.
