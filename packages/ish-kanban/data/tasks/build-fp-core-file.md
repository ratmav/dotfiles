# build ish_file - functional file operations

**dependencies:** build-fp-core-file-descriptor

**priority:** high

## description

Build functional file operation primitives on top of file descriptors. Files are buckets — persistent I/O endpoints. Chained read/write/existence operations that short-circuit on failure with error context.

These wrap POSIX file operations in monadic error handling so callers chain file ops without manual error checking at each step.

## subtasks

- [ ] implement `ish_file_read` - read file contents to stdout, fail with context if missing
- [ ] implement `ish_file_write` - write stdin to file atomically (temp + mv), fail with context
- [ ] implement `ish_file_append` - append stdin to file, fail with context
- [ ] implement `ish_file_exists` - predicate for filter/guard
- [ ] implement `ish_file_require` - assert file exists or fail with message
- [ ] implement `ish_file_bind` - chain file operations with error propagation
- [ ] write unit tests for each primitive
- [ ] test monad laws (identity, composition) for file_bind
- [ ] document with type signatures and examples

## deliverable

`core/source/file.sh` with tested FP primitives

## notes

**Concrete patterns from kanban to extract:**
- `kanban.sql` export: write db dump to file atomically (temp + mv)
- `kanban.sql` import: read file, pipe to sqlite3
- migration file reads: read each `.sql` file in order, fail if any missing
- existence checks: does `kanban.sql` exist? does `kanban.db` exist?

**Type signatures:**
```bash
# @type: filepath -> IO string | error
ish_file_read()

# @type: filepath -> stdin -> IO () | error
ish_file_write()

# @type: filepath -> stdin -> IO () | error
ish_file_append()

# @type: filepath -> bool
ish_file_exists()

# @type: filepath -> string -> IO () | error
ish_file_require()

# @type: (filepath -> IO b) -> IO filepath -> IO b | error
ish_file_bind()
```

**Atomic writes are critical.** `ish_file_write` must use temp file + mv pattern. a failed write must not corrupt the target file. this is especially important for `kanban.sql` — a half-written dump is worse than no write at all.

**Performance characteristics:**

File operations are I/O bound, not CPU bound. process spawn overhead is negligible compared to disk access.

- Read/write cost: dominated by file size, not operation count
- Atomic write: 2x disk ops (write temp + mv), but mv is rename on same filesystem (near-instant)
- Acceptable for: any file size ish will encounter (task specs, SQL dumps, config files)
- No practical performance ceiling for this use case

**Testing:**
- [ ] Unit tests for correctness (read/write/exists/require)
- [ ] Test atomic write: verify no corruption on simulated failure
- [ ] Test error propagation through bind chains
- [ ] Test with empty files, missing files, no-permission files
