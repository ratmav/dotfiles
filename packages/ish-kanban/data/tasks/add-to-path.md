# implement ish install

**phase:** 4

**dependencies:** none

## description

make ish callable from anywhere with tab completion. `ish install` modifies current system shell config to add PATH entry and completion sourcing so bootstrap works later.

## subtasks

- [ ] implement `ish install` command (see `registry_commands.md`)
  - check if `~/.ish/core/bin` is in PATH
  - if not, add to shell config (default `~/.bashrc`, `--config=PATH` for others)
  - check if completion is sourced
  - if not, add completion sourcing
  - idempotent
- [ ] implement `core/source/completion.sh`
  - `_ish_completion()` function
  - discover commands dynamically from `core/source/` and `packages/`
  - handle nested routing (e.g., `ish ratfiles git clean prune`)
  - complete flags (`--help`, `--config`, etc.)
- [ ] test on current system
  - verify `ish help` works from any directory
  - verify `ish <tab>` shows available commands
  - verify nested completion works (e.g., `ish ratfiles <tab>`)

## deliverable

`ish install` works, shell config has PATH entry and completion sourcing, tab completion works for all commands.

## notes

**install pattern:**
install modifies current system. when `ish ratfiles bootstrap posix all` runs later, it symlinks dotfiles config which already has ish in PATH and completion. no need to call install again.

**completion sourcing:**
```bash
if command -v ish >/dev/null 2>&1; then
  source "$(dirname "$(readlink -f "$(command -v ish)")")/../source/completion.sh"
fi
```

completion is convention-driven like routing. no hardcoded command lists. if a new command is added, completion discovers it automatically.
