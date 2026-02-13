# kanban-board-mutations

**milestone:** 1 - restructure

**dependencies:** kanban-board-parser

**priority:** high

## description

Add board mutation operations to `board.sh` for adding/removing task references.

Implement:
- `ish_kanban_board_add_task()` - insert task reference in todo section with priority order
- `ish_kanban_board_remove_task()` - remove task reference from any section

Use temp file for atomic updates (write to temp, then mv).
Priority sorting: high < medium < low (alphabetical within same priority).
Renumber entire todo list when inserting to maintain sequential 1,2,3... format.

## deliverable

- Two mutation functions in `board.sh`
- Atomic update pattern implemented
- Integration tests for add/remove operations
