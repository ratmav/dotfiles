# complete documentation audit

**phase:** 1

## description

docs have stale naming, specific examples that rot, references to old `bash/` paths, and most files exceed the 100-line target. audit all docs: fix stale content, genericize examples, split large files.

## remaining work

### step 4: split vision.md
- [ ] split into vision/ directory with focused files
- [ ] fix stale tui_* function names during split

### step 5: split remaining large core docs
- [ ] philosophy.md (235 lines)
- [ ] explicit_routing.md (69 lines — under limit, just fix stale content)
- [ ] fix bash/ refs and generic examples during split

### step 6: split large architecture docs
- [ ] package_loading.md (335), overview.md (245), migration_path.md (198)
- [ ] task_reconciliation.md (186), registry_commands.md (184), package_types.md (152)
- [ ] module_loading_system.md (113), monads.md (129), primitives.md (107)
- [ ] fix stale content during split

### step 7: split large kanban docs
- [ ] data_model.md (161), cli_workflow.md (102)

### step 8: fix stale references in remaining small files
- [ ] kanban task files (add-to-path.md, scaffolding.md, implement-module-namespace-linter.md)
- [ ] any remaining stale content caught in final sweep

## deliverable

all docs use current naming, generic examples, and accurate paths. no file exceeds 100 lines. no stale references.
