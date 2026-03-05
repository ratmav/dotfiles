# split sqlite.sh into sqlite/ subdirectory

**dependencies:** build-fp-core-git (git split establishes the pattern)

**priority:** high

## context

tests are already split into `core/test/unit/sqlite/` (require, query, query_one, exec, load, dump, transaction, escape) but source is still a single `core/source/sqlite.sh`. split source to match test structure for discovery, same as the git split.

## subtasks

- [ ] split `sqlite.sh` into `sqlite/` subdirectory (require, query, query_one, exec, load, dump, transaction, escape)
- [ ] verify tests still pass after split

## deliverable

`core/source/sqlite/` with one file per operation, matching `core/test/unit/sqlite/` structure. no functional changes — pure structural split.
