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

## edge cases and error handling

**Timeout semantics:**
- [ ] Design timeout strategy:
  - Short commands (< 30s): 60s timeout
  - Long commands (bootstrap): 30min timeout
  - Allow override: `--timeout=600`
- [ ] Implement configurable timeouts
- [ ] Test with long-running bootstrap (20+ minutes)

**Partial failure recovery:**
- [ ] Design checkpointing strategy (optional)
- [ ] Document idempotency requirements
- [ ] Test: network dies at 90% completion → can rerun?

**PTY allocation:**
- [ ] Test: `ssh host 'sudo cmd'` (may fail - no TTY)
- [ ] Test: `ssh -t host 'sudo cmd'` (forces TTY)
- [ ] Decide: always use -t? Only for sudo? Configurable?
- [ ] Document PTY requirements

**SSH requirements:**
- [ ] Document: key-based auth required (no password prompts)
- [ ] Document: known_hosts handling (strict? accept-new?)
- [ ] Test: fresh host (not in known_hosts)
- [ ] Test: host key changed (known_hosts conflict)
- [ ] Test: SSH agent forwarding (required? optional?)

**Error handling:**
- [ ] Capture remote exit codes correctly
- [ ] Stream stderr separately from stdout
- [ ] Handle: remote command not found
- [ ] Handle: permission denied
- [ ] Handle: network interruption mid-command

## deliverable

`ish --remote=host bootstrap all` works

## notes

prove the pattern works in the battle-tested monolith first before framework split
