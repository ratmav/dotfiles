# split sqlite.sh into sqlite/ subdirectory

**dependencies:** build-fp-core-git (git split establishes the pattern)

**priority:** high

## context

tests are already split into `core/test/unit/sqlite/` (require, query, query_one, exec, load, dump, transaction, escape) but source is still a single `core/source/sqlite.sh`. split source to match test structure for discovery, same as the git split.

## subtasks

- [ ] add escaping to exec, query, transaction, dump, load — `ish_sqlite_escape` exists but is never called internally. design decision needed: where does escaping belong?
- [ ] DRY: exec and query are structurally identical except for `-separator '|'`. consider a shared internal function.

## deliverable

`core/source/sqlite/` with one file per operation, matching `core/test/unit/sqlite/` structure.
