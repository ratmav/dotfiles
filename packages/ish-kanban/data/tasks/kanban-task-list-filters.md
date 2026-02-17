# kanban-task-list-filters

**milestone:** 1 - restructure

**dependencies:** kanban-sqlite-redesign

**priority:** medium

## description

Enhance `ish_kanban_task_list()` in `task.sh` to support filtering.

Add optional flags:
- `--status=STATUS` - filter by section (todo, completed, in-progress)
- `--milestone=N` - filter by milestone number

Behavior:
- No flags: list all task files (existing behavior)
- With flags: parse board, filter by location

Use board parser to determine task locations, then filter results.

Note: `--status=in-progress` (hyphenated flag) maps to `### in progress` (board section with space).

## deliverable

- Enhanced `ish_kanban_task_list()` with filters
- Updated help text with filter examples
- Integration tests for filtering
