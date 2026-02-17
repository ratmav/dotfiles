# rename-kanban-show-to-board

**milestone:** 1 - restructure

**dependencies:** kanban-integration-testing

**priority:** medium

## description

Rename `ish kanban show` → `ish kanban board` for CLI consistency.

Changes:
- Rename `ish_kanban_show()` → `ish_kanban_board()` in `kanban.sh`
- Update routing: `show` case → `board` case
- Update help text to show `board` instead of `show`
- Update all tests to use `board` instead of `show`
- Update documentation/comments

This follows the pattern: `ish kanban board`, `ish kanban task`, `ish kanban scratch`.

## deliverable

- Renamed function and routing
- Updated help text
- All tests passing with new command name
