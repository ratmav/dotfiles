# build ish_git - functional git operations

**dependencies:** build-fp-core-stream, build-fp-core-file, build-fp-core-pipe

**priority:** high

## subtasks

- [ ] document in `core/docs/architecture/extensions.md`

## deferred

`ish_git_status` and `ish_git_is_clean` have no consumer until ratfiles refactor (phase 2). build them when their first consumer exists.

## deliverable

`extensions/source/git.sh` (router) and `extensions/source/git/` (operations) with tested functions. documented in `core/docs/architecture/extensions.md`.
