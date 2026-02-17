# complete documentation audit

**phase:** 1

**dependencies:** fix-module-dir-namespacing (spec must be correct before docs reference it)

## description

docs have stale naming, specific examples that rot, and references to old paths. audit all docs and align with current conventions. use generic foo_bar examples to prevent future rot.

## subtasks

- [ ] finish conventions.md cleanup (remaining `bash/` path references, stale code examples)
- [ ] update conventions.md module_dir spec to use function-prefix derivation (not `_core_source_*`)
- [ ] update vision.md for stale framework/project split references
- [ ] verify philosophy.md examples are current
- [ ] verify testing.md examples are current
- [ ] verify architecture/*.md docs are current (overview, migration_path, package_loading, etc.)
- [ ] verify kanban docs are current (cli_workflow, data_model, vim_integration)
- [ ] update kanban tasks with broken dependencies (kanban-task-list-filters, kanban-task-validation, kanban-task-close, kanban-integration-testing reference eliminated tasks)

## deliverable

all docs use current naming, generic examples, and accurate paths. no stale references.
