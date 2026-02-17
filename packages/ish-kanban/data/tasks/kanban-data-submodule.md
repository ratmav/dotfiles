# kanban-data-submodule

**milestone:** 1 - restructure

**dependencies:** none

**priority:** medium

## description

Extract kanban data (`packages/ish-kanban/data/`) into a dedicated git repository and wire it up as a git submodule. Add commands to manage kanban data repositories.

Implement:
- `ish kanban load` - initialize/update data submodule
- `ish kanban remove` - remove data submodule completely
- `ish kanban delete` - remove local data (keep remote)

This separates the kanban code (package) from the kanban data (board, tasks, scratch) so the data can be versioned independently and shared across repos.

## deliverable

- Dedicated git repository for kanban data (board.md, tasks/*.md, scratch.md)
- `packages/ish-kanban/data/` configured as git submodule pointing to data repo
- Three management commands working
- Update path resolution if needed (should work transparently via submodule)
- Tests for load/remove/delete commands
