# fix module_dir namespacing in core

**phase:** 1

**dependencies:** none (blocking — spec violation)

## description

core/source/tui.sh and core/source/utils.sh use short-form `_module_dir` names that violate the full-path namespacing convention. the convention (documented in conventions.md) derives the variable name from the function name prefix to guarantee uniqueness. all packages (ish-ratfiles, ish-kanban) follow this correctly. core does not.

## the spec

variable name = function name prefix for the module + `_module_dir`

working examples (ish-ratfiles):
- `ish_ratfiles_module_dir` (source/ratfiles.sh)
- `ish_ratfiles_bootstrap_posix_module_dir` (source/bootstrap/posix.sh)

violations (core):
- `_tui_module_dir` → should be `ish_tui_module_dir`
- `_utils_module_dir` → should be `ish_utils_module_dir`

## subtasks

- [ ] update conventions.md spec to use function-prefix derivation (not raw file path)
- [ ] rename `_tui_module_dir` → `ish_tui_module_dir` in core/source/tui.sh
- [ ] rename `_utils_module_dir` → `ish_utils_module_dir` in core/source/utils.sh
- [ ] run tests to confirm no breakage
- [ ] audit all other module_dir declarations across codebase for compliance

## deliverable

all module_dir variables follow the function-prefix derivation convention. no short-form names.
