# kanban-task-create-integration

**milestone:** 1 - restructure

**dependencies:** kanban-board-mutations, kanban-task-validation

**priority:** high

## description

Enhance `ish_kanban_task_new()` in `task.sh` to integrate with board.

Changes:
- Add flags: `--milestone` (required), `--description` (required), `--priority` (default: medium), `--dependencies` (default: none)
- Validate all inputs before creating task
- Get milestone description from board
- Create task file with new template (includes priority, dependencies, description content)
- Write description to task file under ## description section
- Add task reference to board in correct milestone/priority order
- Use description flag value directly for board reference (no extraction)
- Update help text with new flags

BREAKING: `--milestone` and `--description` flags now required (fail fast if missing).

## deliverable

- Enhanced `ish_kanban_task_new()` with board integration
- Updated task template with priority and dependencies fields
- Updated help text
- Integration tests for create workflow
