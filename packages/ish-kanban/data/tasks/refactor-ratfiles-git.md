# refactor ratfiles git to use ish atoms

**dependencies:** build-fp-core-git

## description

`packages/ish-ratfiles/source/git/clean.sh` makes raw git and shell calls where ish primitives and extensions exist. refactor to use ish atoms.

## current raw calls to replace

- `git rev-parse --git-dir` → `ish_git_require --dir=`
- `git branch -vv | grep "gone" | awk "{print \$1}"` → `ish_git_*` + `ish_stream_filter` + `ish_stream_map`
- `git rev-parse --show-toplevel` → could wrap if pattern repeats
- `echo "$gone_remote_branch" | xargs git branch -D` → `ish_stream_map` with a delete function

## deferred additions

when this refactor happens, evaluate whether `ish_git_status` and `ish_git_is_clean` have earned their place as core functions. if ratfiles needs them, build them then.

## deliverable

`packages/ish-ratfiles/source/git/clean.sh` using ish atoms instead of raw shell calls. tests pass.
