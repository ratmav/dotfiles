# dependency-tree visualization

**dependencies:** kanban-sqlite-redesign

## description

CLI commands to query and visualize the dependency DAG. The DAG is the core data structure — these commands are how you read it. Ships with the redesign, not after.

## subtasks

- [ ] implement `ish kanban deps` — show full dependency tree (ascii or mermaid)
  - highlight cycles if present
- [ ] implement `ish kanban next` — show tasks with no unmet dependencies
  - uses the "open tasks" query from data_model.md
- [ ] implement `ish kanban blocked` — show tasks waiting on dependencies
  - show what blocks each task
- [ ] add tests for dependency queries
- [ ] document in conventions.md

## deliverable

dependency tree commands implemented, enabling dependency-aware task selection

## notes

**queries already exist.** the open/blocked/blockers/unblocks queries are defined in `packages/ish-kanban/docs/data_model.md`. these commands are thin CLI wrappers around those queries via the model layer.

**no parsing needed.** the old task described parsing markdown files for dependency fields. with SQLite, the dependency graph is a table — just query it.
