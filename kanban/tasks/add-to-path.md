# 003: implement ish install

**milestone:** 1 - local experience

**dependencies:** none

## description

make ish callable from anywhere with tab completion. `ish install` modifies current system. dotfiles/.bashrc gets PATH entry and completion sourcing so bootstrap works later.

## subtasks

- [ ] implement `ish install` command
  - check if ish is in PATH
  - if not, add to current system ~/.bashrc
  - check if completion is sourced
  - if not, add completion sourcing to current system ~/.bashrc
  - source ~/.bashrc
- [ ] add ish to PATH in dotfiles/.bashrc
- [ ] implement bash/completion.sh
  - `_ish_completion()` function
  - discover commands dynamically from bash/ directory structure
  - handle nested routing (e.g., `ish git clean prune`)
  - complete flags (--help, --remote, etc.)
- [ ] add completion sourcing to dotfiles/.bashrc
- [ ] test on current system
  - verify `ish help` works from any directory
  - verify `ish <tab>` shows available commands
  - verify nested completion works (e.g., `ish git <tab>`)

## deliverable

`ish install` works, dotfiles/.bashrc has PATH entry and completion sourcing, tab completion works for all commands

## notes

**install pattern:**
install modifies current system. when `ish bootstrap posix all` runs later, it symlinks dotfiles/.bashrc → ~/.bashrc (which already has ish in PATH and completion). no need to call install again.

**completion sourcing:**
```bash
# In ~/.bashrc and dotfiles/.bashrc
if command -v ish >/dev/null 2>&1; then
  source "$(dirname "$(readlink -f "$(command -v ish)")")/bash/completion.sh"
fi
```

**why discover via PATH:**
- portable: no hardcoded paths, works wherever ish is installed
- convention-driven: relies on ish in PATH (established by install)
- self-hosting: ish discovers its own completion
- framework-ready: works after Phase 3 split
- remote-friendly: works on any system with ish in PATH
- module-aware: can extend to discover module commands dynamically (Phase 4)

completion is convention-driven like routing. no hardcoded command lists. if a new command is added to bash/, completion discovers it automatically.
