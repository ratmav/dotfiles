# build ish_git - functional git operations

**dependencies:** build-fp-core-stream, build-fp-core-file, build-fp-core-pipe

**priority:** high

## subtasks

- [ ] split `git.sh` into `git/` subdirectory (require, add, commit, push, pull) for legibility — same pattern as sqlite split
- [ ] document in `core/docs/architecture/integrations.md`

## deferred

`ish_git_status` and `ish_git_is_clean` have no consumer until ratfiles refactor (phase 2). build them when their first consumer exists.

## deliverable

`core/source/git.sh` (and `git/` subdirectory after split) with tested functions. documented in `core/docs/architecture/integrations.md`.

## lessons learned

**`--dir=` over `cd`.** all functions accept `--dir=` and use `git -C` internally. no global state mutation. callers stay in their original directory regardless of success or failure. this was a design decision for the kanban data submodule write path — the submodule is a different directory than the main repo.

**test runner directory fallback.** splitting tests into subdirectories broke `--route=module` because the runner only looked for `.bats` files. fixed `core/source/test.sh` to fall through to directory with `ish_tui_warn` — warns about missing parent test file but still runs. applies to both unit and integration runners.

**source split for legibility.** sqlite and git both have single source files with many test files. decided to split source to match test structure for discovery, not line count. pending for both modules.
