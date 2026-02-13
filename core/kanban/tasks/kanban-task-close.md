# kanban-task-close

**milestone:** 1 - restructure

**dependencies:** kanban-board-mutations

**priority:** high

## description

Replace `ish_kanban_task_delete()` with `ish_kanban_task_close()` in `task.sh`.

New close command:
- Remove task reference from board (any section)
- Delete task file
- Order matters: remove from board first (safer)

Update routing:
- Add `close` case
- REMOVE `delete` case (breaking change)

Update help text to show `close` instead of `delete`.

## deliverable

- New `ish_kanban_task_close()` function
- Updated routing (delete removed)
- Updated help text
- Integration tests for close workflow
