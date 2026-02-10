# add comprehensive help tests for all routers

**milestone:** 1 - restructure

**dependencies:** fix-cli-consistency.md (completed)

## description

Add help tests for all routing layers to prevent regression. Currently have tests for some routers (test, git, kanban, platform) but missing coverage for lint, dotfiles, bootstrap platforms, and kanban subcommands.

**Why:** Ensures all routers consistently support `help` command and show clean help output.

## missing test coverage

**Top-level routers:**
- [ ] lint help
- [ ] dotfiles help

**Bootstrap platform routers:**
- [ ] dotfiles bootstrap posix help
- [ ] dotfiles bootstrap kali help
- [ ] dotfiles bootstrap macos homebrew help (added in fix-cli-consistency)

**Kanban subcommand routers:**
- [ ] kanban task help
- [ ] kanban scratch help

## subtasks

### 1. Create test files for missing routers
- [ ] Create `packages/ish/test/integration/lint.bats`
- [ ] Create `packages/ish/test/integration/dotfiles.bats`

### 2. Add help tests to lint.bats
- [ ] Test: `./ish lint help` shows usage
- [ ] Test: `./ish lint` (no args) shows help

### 3. Add help tests to dotfiles.bats
- [ ] Test: `./ish dotfiles help` shows usage
- [ ] Test: `./ish dotfiles` (no args) shows help

### 4. Add help tests to bootstrap platform files
- [ ] Add to `packages/ish/test/integration/bootstrap/posix.bats`:
  - Test: `./ish dotfiles bootstrap posix help` shows usage
  - Test: `./ish dotfiles bootstrap posix` (no args) shows help
- [ ] Add to `packages/ish/test/integration/bootstrap/kali.bats`:
  - Test: `./ish dotfiles bootstrap kali help` shows usage
  - Test: `./ish dotfiles bootstrap kali` (no args) shows help

### 5. Add help tests to kanban.bats
- [ ] Test: `./ish kanban task help` shows usage
- [ ] Test: `./ish kanban scratch help` shows usage

### 6. Verify all tests pass
- [ ] Run `./ish test integration` and check for failures
- [ ] Confirm all routers have help test coverage

## deliverable

Complete test coverage for help support across all routing layers. No router can break help functionality without tests catching it.

## critical files

**New files:**
- `packages/ish/test/integration/lint.bats` - CREATE
- `packages/ish/test/integration/dotfiles.bats` - CREATE

**Update files:**
- `packages/ish/test/integration/bootstrap/posix.bats` - ADD help tests
- `packages/ish/test/integration/bootstrap/kali.bats` - ADD help tests
- `packages/ish/test/integration/kanban.bats` - ADD kanban task/scratch help tests

## verification

All these commands should have test coverage:
```bash
./ish test help
./ish lint help
./ish dotfiles help
./ish dotfiles bootstrap help
./ish dotfiles bootstrap posix help
./ish dotfiles bootstrap kali help
./ish dotfiles bootstrap macos help
./ish dotfiles bootstrap macos homebrew help
./ish dotfiles git help
./ish dotfiles git clean help
./ish dotfiles nix help
./ish kanban help
./ish kanban task help
./ish kanban scratch help
./ish utils help
./ish platform help
```
