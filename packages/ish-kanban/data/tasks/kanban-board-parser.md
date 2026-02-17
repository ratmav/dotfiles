# kanban-board-parser

**milestone:** 1 - restructure

**dependencies:** none

**priority:** high

## description

Create `core/source/kanban/board.sh` with board parsing and validation functions.

Implement:
- `ish_kanban_board_parse()` - state machine parser to extract task locations from board
- `ish_kanban_board_get_milestone_desc()` - extract milestone descriptions (e.g., "1 - restructure")
- `ish_kanban_board_validate_milestone()` - validate milestone exists in board

Use awk for state machine parsing. Track current phase and section as state variables.

## deliverable

- New file: `core/source/kanban/board.sh`
- Three parser functions working
- Unit tests for parser logic
