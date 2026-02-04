# dependency-tree visualization

**milestone:** 1 - local experience

**dependencies:** kanban-refactor

## description

parse standardized task format to build and visualize dependency trees. helps identify what's ready to work on, what's blocked, and critical paths.

## subtasks

- [ ] implement task parser
  - read all task files
  - extract dependencies field
  - build dependency graph
- [ ] implement `ish kanban deps` - show full dependency tree
  - graphical representation (mermaid or ascii)
  - highlight cycles if present
- [ ] implement `ish kanban next` - show tasks with no unmet dependencies
  - filter for tasks ready to work on
  - exclude completed tasks
  - show priority order
- [ ] implement `ish kanban blocked` - show tasks waiting on dependencies
  - list blocking dependencies
  - show what needs to complete first
- [ ] add tests for dependency resolution
- [ ] document in conventions.md

## deliverable

dependency tree commands implemented, enabling dependency-aware task selection

## notes

**standardized format enables automation:**
task files have consistent structure with `**dependencies:**` field. this makes parsing straightforward and enables automatic dependency management.

**future enhancement:**
could integrate with `ish kanban task new` to validate dependencies exist when creating tasks.
