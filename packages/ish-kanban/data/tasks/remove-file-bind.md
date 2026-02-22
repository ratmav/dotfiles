# remove-file-bind

**dependencies:** none (build-fp-core-file is complete)

**priority:** immediate — do before next phase 1 work

## description

`ish_file_bind` is a duplicate of `ish_stream_bind`. They're identical code with different error prefixes. The insight: bash is stream-oriented (data flows through pipes), the OS is file-oriented (data at rest on disk). Bind iterates stdin lines — that's a stream operation regardless of what the data represents. `file.sh` should own filesystem operations only: read, write, append, exists, require.

## subtasks

- [ ] remove `ish_file_bind` function from `core/source/file.sh`
- [ ] remove all `file_bind` tests from `core/test/unit/file.bats` (bind, short-circuit, monad laws — 6 tests)
- [ ] grep for any callers of `ish_file_bind` in the codebase and replace with `ish_stream_bind`
- [ ] update `core/docs/architecture/monads.md` — remove `file_bind` references, bind lives in `stream.sh` only
- [ ] update `core/docs/architecture/primitives.md` — remove file bind from type signatures if present
- [ ] update `core/docs/architecture/layers.md` — file module description should not mention bind
- [ ] verify all unit tests pass
- [ ] verify all integration tests pass

## deliverable

`file.sh` owns filesystem operations. `stream.sh` owns stdin iteration (including bind). No duplication between them.
