# fix CLI consistency paper cuts

**milestone:** 1 - restructure

**dependencies:** none

## description

Fix CLI inconsistencies discovered during audit. Current behavior is mostly good (routing layers show help, leaves execute), but has 3 paper cuts that create confusion.

## paper cuts found

### 1. Missing `help` command in git clean router

**Current behavior:**
```bash
./ish dotfiles git help          # ✓ works
./ish dotfiles git clean help    # ✗ fails: "unknown git clean command: help"
```

**Expected:** All routing layers should support `help` as a command.

**Fix:** Update `packages/dotfiles/source/git/clean.sh` routing to handle `help` case.

### 2. Inconsistent bootstrap platform depth

**Current behavior:**
```bash
./ish dotfiles bootstrap posix           # shows: all, nix (2 subcommands)
./ish dotfiles bootstrap posix all       # executes

./ish dotfiles bootstrap macos           # shows: all, homebrew
./ish dotfiles bootstrap macos all       # executes
./ish dotfiles bootstrap macos homebrew  # shows: install, packages (another router!)
```

**Issue:** `macos` has deeper nesting than `posix`. The `homebrew` layer adds an extra routing level that `posix` doesn't have.

**Options:**
- **Option A:** Flatten `macos` - move homebrew commands up (e.g., `macos homebrew-install`)
- **Option B:** Keep depth, document that some platforms have deeper hierarchies
- **Option C:** Nest `posix` commands similarly (e.g., `posix nix-install` → `posix nix install`)

**Recommendation:** Option B - keep as-is, document. Platforms have different complexity.

### 3. Error message leaking into help output

**Current behavior:**
```bash
./ish dotfiles bootstrap macos homebrew
# Output:
# usage: ish dotfiles bootstrap macos homebrew [command]
# --message= required
```

**Issue:** Error "--message= required" appears after help text.

**Fix:** Find where this error is coming from and remove it.

## subtasks

### 1. Fix git clean help support
- [ ] Read `packages/dotfiles/source/git/clean.sh`
- [ ] Add `help` case to routing switch
- [ ] Verify `./ish dotfiles git clean help` shows help

### 2. Investigate and fix macos homebrew error
- [ ] Read `packages/dotfiles/source/bootstrap/macos.sh`
- [ ] Find where "--message= required" error comes from
- [ ] Fix so help output is clean
- [ ] Verify `./ish dotfiles bootstrap macos homebrew` shows clean help

### 3. Document platform depth differences (if keeping)
- [ ] Update help text to clarify platform-specific depth
- [ ] Consider adding examples to help showing full command paths

### 4. Verify all routing layers support help
- [ ] Audit all routing functions for `help` case support
- [ ] Add `help` case to any missing routers

## deliverable

Clean, consistent CLI behavior:
- All routers support `help` command
- No error messages mixed into help output
- Clear help text for all commands

## critical files

- `packages/dotfiles/source/git/clean.sh` - Add help support
- `packages/dotfiles/source/bootstrap/macos.sh` - Fix error in help
- Potentially other routers needing `help` case

## verification

```bash
# All should show clean help (no errors)
./ish dotfiles git clean help
./ish dotfiles bootstrap macos homebrew
./ish dotfiles bootstrap macos homebrew help

# All routing layers support help
./ish test help
./ish lint help
./ish dotfiles help
./ish dotfiles bootstrap help
./ish dotfiles git help
./ish dotfiles git clean help
./ish kanban help
./ish kanban task help
./ish kanban scratch help
```

## notes

**Current behavior is mostly correct:**
- ✅ Routing layers show help with no args
- ✅ Executable leaves execute immediately
- ✅ Read-only commands execute immediately
- ✅ Commands with required params show clear errors

**No --run flag needed** - standard CLI pattern works fine. Just need to fix these 3 inconsistencies.
