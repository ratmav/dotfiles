# kanban-data-submodule

**dependencies:** kanban-sqlite-redesign

**priority:** medium

## description

Extract `packages/ish-kanban/data/` into a dedicated git repository and wire it up as a git submodule. This separates kanban code (package, in main repo) from kanban data (tasks, in submodule) so data can be versioned and synced independently across machines.

The submodule contains:
- `kanban.sql` — committed, text, mergeable. data INSERTs only (no schema).
- `kanban.db` — `.gitignore`'d. runtime cache rebuilt from migrations + `kanban.sql`.

## sync model

writes auto-commit and push in the submodule. if anything fails (conflict, no remote, network), ish errors and tells the user to resolve manually. conflicts in `kanban.sql` are normal text merge conflicts — resolved by the user in their editor.

## deliverable

- Dedicated git repository for kanban data
- `packages/ish-kanban/data/` configured as git submodule
- `.gitignore` in data repo excluding `kanban.db`
- Auto-export of `kanban.sql` after write operations (already spec'd in kanban-sqlite-redesign)
- Auto-import from `kanban.sql` when db is missing (already spec'd in kanban-sqlite-redesign)
