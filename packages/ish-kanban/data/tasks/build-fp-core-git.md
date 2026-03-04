# build ish_git - functional git operations

**dependencies:** build-fp-core-stream, build-fp-core-file, build-fp-core-pipe

**priority:** high

## description

build functional git integration that composes core stream and file primitives around shell calls to `git`. not a bash primitive — this is a composition layer over an external binary. git output flows through stream, file operations (staging, working tree) flow through file.

each function provides its own error context — what failed, where, and what the user should do about it. callers compose operations with `&&`.

all functions accept `--dir=` to specify the target repo. uses `git -C` internally — no `cd`, no global state mutation. callers stay in their original directory regardless of success or failure.

## consumer

kanban data submodule write path (see `packages/ish-kanban/docs/data_infrastructure.md`):
- on write: `git add kanban.sql && git commit && git push` in the data submodule
- on entry: `git pull` to stay current
- on entry: require git exists and we're in a repo

## subtasks

- [ ] implement `ish_git_require` — assert git exists + `--dir=` is a repo, fail with context
- [ ] implement `ish_git_add` — stage files, fail with context
- [ ] implement `ish_git_commit` — commit staged changes with message, fail with context
- [ ] implement `ish_git_push` — push to remote, fail with context
- [ ] implement `ish_git_pull` — pull from remote, fail with context
- [ ] write unit tests for each function (temp git repos as fixtures)
- [ ] document in `core/docs/architecture/integrations.md`

## deferred

`ish_git_status` and `ish_git_is_clean` have no consumer until ratfiles refactor (phase 2). build them when their first consumer exists.

## deliverable

`core/source/git.sh` with tested functions

## notes

**type signatures:**
```bash
# @type: --dir=string -> IO () | error
ish_git_require --dir="$data_dir"

# @type: --dir=string --path=string [...] -> IO () | error
ish_git_add --dir="$data_dir" --path="kanban.sql"

# @type: --dir=string --message=string -> IO () | error
ish_git_commit --dir="$data_dir" --message="update kanban data"

# @type: --dir=string -> IO () | error
ish_git_push --dir="$data_dir"

# @type: --dir=string -> IO () | error
ish_git_pull --dir="$data_dir"
```

**callers compose with `&&`:**
```bash
local data_dir="$(ish_packages_data_dir "ish-kanban")"
ish_git_add --dir="$data_dir" --path="kanban.sql" \
  && ish_git_commit --dir="$data_dir" --message="update kanban data" \
  && ish_git_push --dir="$data_dir"
```

**error context is critical.** a bare "push failed" is useless. each function must include what failed, where (which repo/directory), and what the user should do about it. example: `"git push failed in packages/ish-kanban/data/ — resolve conflicts manually and push"`. `--dir=` value is included in every error message.

**failure modes (all must produce actionable error messages):**
- `git require`: git not installed, `--dir=` not a repo
- `git add`: file doesn't exist, not in a repo
- `git commit`: nothing staged, hook failure
- `git push`: no remote, auth failure, conflicts, network timeout
- `git pull`: conflicts, network timeout, diverged history
