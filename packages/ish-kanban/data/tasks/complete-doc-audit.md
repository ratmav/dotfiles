# complete documentation audit

**phase:** 1

## description

docs have stale naming, specific examples that rot, references to old `bash/` paths, and most files exceed the 100-line target. audit all docs: fix stale content, genericize examples, split large files.

## remaining work

### step 6: split large architecture docs (in progress)
- [x] deleted task_reconciliation.md (superseded by reconcile-task-architecture task)
- [x] deleted module_loading_system.md (duplicate of package_loading.md; namespace collision content folded into conventions/naming.md)
- [x] replaced package_loading.md (335), overview.md (245), package_types.md (152) with package_system.md (76), package_loading.md (69), design_decisions.md (39)
- [x] replaced registry_commands.md (184) with updated registry_commands.md (63) — corrected registry model (PR-managed, not user-modified), added update rollback, removed stale `ish self` commands
- [ ] update migration_path.md (198) — stale paths, but board references steps 3/4/5
- [ ] delete old overview.md and package_types.md
- [ ] monads.md (129), primitives.md (107) — borderline, assess for split

### step 7: split large kanban docs
- [ ] data_model.md (161), cli_workflow.md (102)

### step 8: fix stale references in remaining small files
- [ ] kanban task files (add-to-path.md, scaffolding.md, implement-module-namespace-linter.md)
- [ ] any remaining stale content caught in final sweep

## deliverable

all docs use current naming, generic examples, and accurate paths. no file exceeds 100 lines. no stale references.
