# complete documentation audit

**phase:** 1

**dependencies:** fix-module-dir-namespacing (done)

## description

docs have stale naming, specific examples that rot, references to old `bash/` paths, and most files exceed the 100-line target. audit all docs: fix stale content, genericize examples, split large files.

## audit findings

**stale content (30+ instances):**
- `bash/` path references across conventions.md, testing.md, explicit_routing.md, philosophy.md, vision.md, kanban source comments, kanban task files
- old function names without `ish_` prefix (tui_info, utils_is_installed, etc.)
- specific examples that should be generic foo_bar (conventions.md, philosophy.md)
- broken `kanban-board-parser` dependency in 3 task files

**files over 100 lines (15 files):**
- conventions.md (1388), vision.md (545), testing.md (473)
- package_loading.md (335), overview.md (245), philosophy.md (235)
- migration_path.md (198), task_reconciliation.md (186), registry_commands.md (184)
- package_types.md (152), data_model.md (161), monads.md (129)
- module_loading_system.md (113), primitives.md (107), cli_workflow.md (102)

## steps (cumulative, one commit each)

### step 1: mechanical fixes
- [ ] remove `kanban-board-parser` dependency from kanban-task-validation.md, kanban-task-list-filters.md, kanban-sqlite-redesign.md
- [ ] fix stale comments in packages/ish-kanban/source/kanban/task.sh and scratch.sh

### step 2: split conventions.md
- [ ] split into conventions/ directory with focused files:
  - naming.md — core principles, function naming, file organization (~230 lines → split further if needed)
  - routing.md — routing pattern, CLI structure, help text (~287 lines → split further if needed)
  - architecture.md — DAG, sourcing, env vars, module vars (~305 lines → split further if needed)
  - coding_style.md — local vars, error handling, output patterns, stream separation (~391 lines → split further if needed)
  - testing.md — testing conventions section (~130 lines)
- [ ] fix all bash/ refs, old function names, specific examples during split
- [ ] replace conventions.md with index linking to new files

### step 3: split testing.md
- [ ] split into testing/ directory with focused files
- [ ] fix all bash/ refs and old function names during split

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
