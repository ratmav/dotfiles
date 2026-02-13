# kanban-source-board-module

**milestone:** 1 - restructure

**dependencies:** kanban-board-parser

**priority:** high

## description

Update `core/source/kanban.sh` to source the new board module.

Add source statement:
```bash
source "${ish_kanban_module_dir}/kanban/board.sh"
```

Place after other source statements, ensure functions available to task module.

## deliverable

- `kanban.sh` sources `board.sh`
- Board functions available in task module
- No regressions in existing kanban commands
