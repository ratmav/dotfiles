# add --run/--help pattern to executable leaves

**milestone:** 1 - restructure

**parent task:** execute migration_path.md Step 1 (12-step restructure)

**dependencies:** complete-namespace-restructure.md (must complete first)

## description

Make executable leaves unambiguous by requiring explicit `--run` flag to execute. By default, leaves show help explaining what they do and how to run them.

**Problem:** Currently, when you type `ish test unit`, tests execute immediately. For new users, it's unclear whether a command will execute or show help until it happens.

**Solution:** Executable leaves default to showing help. Use `--run` to actually execute.

**Example:**
```bash
ish test unit          # shows help: "Run unit tests. Use --run to execute."
ish test unit --help   # same as above (explicit)
ish test unit --run    # executes unit tests
```

## subtasks

### 1. Define executable leaves

Identify all commands that execute actions (not just routing/help):

**ish package:**
- [ ] `test unit` - runs unit tests
- [ ] `test integration` - runs integration tests
- [ ] `test all` - runs all tests
- [ ] `lint all` - lints all files
- [ ] `lint bash` - lints bash scripts

**dotfiles package:**
- [ ] `dotfiles bootstrap posix` - installs posix tools
- [ ] `dotfiles bootstrap kali` - installs kali tools
- [ ] `dotfiles bootstrap macos` - installs macOS tools
- [ ] `dotfiles git clean prune` - deletes merged branches
- [ ] `dotfiles nix semantic` - generates nix config

**kanban package:**
- [ ] `kanban task add` - creates task
- [ ] `kanban task update` - updates task
- [ ] `kanban task remove` - deletes task

### 2. Update leaf implementations

For each executable leaf:
- [ ] Add `--run` and `--help` flag handling
- [ ] Default behavior (no flags) shows help
- [ ] `--help` explicitly shows help
- [ ] `--run` executes the action
- [ ] Help text includes: "Use --run to execute"

**Pattern:**
```bash
ish_test_unit() {
  local run=false

  while [[ $# -gt 0 ]]; do
    case $1 in
      --run)
        run=true
        shift
        ;;
      --help)
        # show help and exit (default behavior)
        shift
        ;;
      --route=*)
        route="${1#*=}"
        shift
        ;;
      *)
        utils_tui_error --message="unknown option: $1"
        return 1
        ;;
    esac
  done

  if [[ "$run" != "true" ]]; then
    utils_stream_multiline_stderr <<EOF
usage: ish test unit [options]

Run unit tests for the ish package.

options:
  --run           execute the tests
  --help          show this help message
  --route=PATH    run specific test file (e.g., tui/template)

example:
  ish test unit --run                    # run all unit tests
  ish test unit --run --route=tui        # run specific test

Use --run to execute.
EOF
    return 0
  fi

  # Original test execution logic here
  local test_path
  if [[ -n "$route" ]]; then
    test_path="${ISH_PACKAGES_DIR}/ish/test/unit/${route}.bats"
  else
    test_path="${ISH_PACKAGES_DIR}/ish/test/unit/"
  fi

  "${ISH_PACKAGES_DIR}/../test/bats/bin/bats" --recursive "$test_path"
}
```

### 3. Update routing layers

Routing functions (like `ish_test_route`) should NOT change - they just pass args through to leaf functions.

### 4. Verify all leaves

Test each executable leaf:
- [ ] No args → shows help
- [ ] `--help` → shows help
- [ ] `--run` → executes action
- [ ] Invalid flag → shows error

### 5. Update documentation

- [ ] Update `docs/testing.md` with new pattern
- [ ] Update `docs/conventions.md` CLI section
- [ ] Add examples to help text showing `--run` usage

## deliverable

All executable leaves require `--run` to execute. Help is clear and unambiguous. Users know exactly what will happen before a command runs.

## future enhancement

Add `--dry-run` flag for preview mode:
```bash
ish dotfiles git clean prune --dry-run    # shows what would be deleted
ish dotfiles git clean prune --run        # actually deletes branches
```

This is out of scope for this task but should be considered for phase 2.

## notes

**Why this pattern:**
- Unambiguous: User always knows if a command will execute
- Safe: Can't accidentally run destructive operations
- Discoverable: Help text shows what the command does before running
- Consistent: Same pattern across all executable leaves

**Not affected:**
- Routing commands (still show help when given no args)
- Read-only commands that already show output (like `kanban show`)
- Commands with required parameters (already error if missing)
