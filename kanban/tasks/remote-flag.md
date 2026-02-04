# 001: design and implement --remote flag

**milestone:** 2 - remote execution

**dependencies:** phase 1 complete (options pattern, local experience stable)

## description

enable any ish command to execute remotely via `--remote=host` flag. this makes ish a general-purpose task runner for infrastructure management.

## subtasks

- [ ] parse `--remote=host` before routing
- [ ] copy ish to remote via ssh
- [ ] execute command remotely
- [ ] stream output back to local terminal
- [ ] handle errors and exit codes properly

## deliverable

`ish --remote=host bootstrap all` works

## notes

prove the pattern works in the battle-tested monolith first before framework split
