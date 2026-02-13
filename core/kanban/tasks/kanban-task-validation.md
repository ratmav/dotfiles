# kanban-task-validation

**milestone:** 1 - restructure

**dependencies:** kanban-board-parser

**priority:** high

## description

Add validation functions to `board.sh` for task metadata.

Implement:
- `ish_kanban_validate_task_name()` - check name follows conventions (lowercase, dashes only)
- `ish_kanban_validate_dependencies()` - check each dependency exists as task file
- `ish_kanban_validate_priority()` - validate priority is low/medium/high

Pattern for task names: `^[a-z][a-z0-9-]*$`

## deliverable

- Three validation functions in `board.sh`
- Validation tests covering valid and invalid inputs
