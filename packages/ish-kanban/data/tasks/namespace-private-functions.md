# namespace private functions

**dependencies:** build-fp-core-sqlite3

**priority:** high

## description

Private functions use bare `_foo` prefix (e.g. `_stream_error`, `_sqlite_error`). Bash has no namespacing — all functions share a single global namespace. A collision between two `_foo_error` functions from different modules would silently shadow one, causing wrong behavior with no warning.

Public functions already namespace correctly (`ish_stream_`, `ish_sqlite3_`, `ish_kanban_`). Privates must follow the same pattern with a leading underscore.

## pattern

- `core/source/foo.sh`: `_foo_bar` → `_ish_foo_bar`
- `packages/ish-kanban/source/kanban/foo.sh`: `_kanban_foo_bar` → `_ish_kanban_foo_bar`
- `packages/ish-ratfiles/source/foo.sh`: `_ratfiles_foo_bar` → `_ish_ratfiles_foo_bar`

## subtasks

- [ ] audit all private functions across core, kanban, ratfiles
- [ ] rename each to include `_ish_` prefix
- [ ] update all callers
- [ ] verify tests pass

## deliverable

All private functions namespaced. No bare `_foo` prefix anywhere.
