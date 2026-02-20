# build ish_git - functional git operations

**dependencies:** build-fp-core-stream, build-fp-core-file, build-fp-core-pipe

**priority:** high

## description

Build functional git integration that composes core stream and file primitives around shell calls to `git`. Not a bash primitive — this is a composition layer over an external binary. Git output flows through stream, file operations (staging, working tree) flow through file.

Each function provides its own error context — what failed, where, and what the user should do about it. Callers compose operations with `&&`.

## subtasks

- [ ] implement `ish_git_add` - stage files, fail with context
- [ ] implement `ish_git_commit` - commit staged changes with message, fail with context
- [ ] implement `ish_git_push` - push to remote, fail with context
- [ ] implement `ish_git_pull` - pull from remote, fail with context (conflicts, network)
- [ ] implement `ish_git_require` - assert git exists and cwd is a repo, or fail
- [ ] implement `ish_git_status` - check working tree state, stream to stdout
- [ ] implement `ish_git_is_clean` - predicate: is working tree clean?
- [ ] write unit tests for each function
- [ ] document with type signatures and examples

## deliverable

`core/source/git.sh` with tested functions

## notes

**Concrete patterns from kanban to extract:**
- write path: `export kanban.sql` → `git add kanban.sql` → `git commit` → `git push` (in data submodule)
- each step depends on the prior succeeding
- any failure (conflict, no remote, network, nothing to commit) stops the chain
- error message tells the user what failed and where to resolve manually

**Type signatures:**
```bash
# @type: [filepath] -> IO () | error
ish_git_add()

# @type: string (message) -> IO () | error
ish_git_commit()

# @type: IO () | error
ish_git_push()

# @type: IO () | error
ish_git_pull()

# @type: IO () | error
ish_git_require()

# @type: IO [line] | error
ish_git_status()

# @type: bool
ish_git_is_clean()
```

**Callers compose with `&&`:**
```bash
ish_git_add "kanban.sql" \
    && ish_git_commit "update kanban data" \
    && ish_git_push
```

Each function provides actionable error context on failure. No bind wrapper needed — `&&` already short-circuits, and error context belongs in the individual functions, not in a generic chaining mechanism.

**Error context is critical.** a bare "push failed" is useless. each function must include what failed, where (which repo/directory), and what the user should do about it. example: `"git push failed in packages/ish-kanban/data/ — resolve conflicts manually and push"`.

**Working directory matters.** git operations are cwd-sensitive. each function must either accept a directory argument or require the caller to set cwd. for kanban, the data submodule is a different directory than the main repo. document this clearly.

**Performance characteristics:**

git operations are I/O + network bound. process spawn is negligible.

- Local operations (add, commit, status): near-instant for small changesets
- Network operations (push, pull): depends on remote, typically < 2s for small repos
- Failure modes: network timeout (configurable), auth failure, conflicts
- No batching strategy needed — operations are inherently sequential

**Failure modes (all must produce actionable error messages):**
- `git add`: file doesn't exist, not in a repo
- `git commit`: nothing staged, hook failure
- `git push`: no remote, auth failure, conflicts, network timeout
- `git pull`: conflicts, network timeout, diverged history

**Testing:**
- [ ] Unit tests for each operation (use temp git repos as fixtures)
- [ ] Test failure modes: no remote, nothing to commit, conflict
- [ ] Test working directory handling (submodule vs main repo)
- [ ] Test is_clean predicate with clean/dirty working trees
