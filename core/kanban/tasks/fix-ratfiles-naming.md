# fix ratfiles naming

**milestone:** 1 - restructure

**dependencies:** implement-package-loading-strategy (complete)

## problem

Legacy "dotfiles" naming remains in ish-ratfiles package structure after the ish-dotfiles → ish-ratfiles rename.

**Current state:**
- Package directory: `packages/ish-ratfiles/` ✓
- Router file: `source/dotfiles.sh` ✗ (should be `ratfiles.sh`)
- Entry point: hardcodes `source/dotfiles.sh` ✗

This violates naming conventions and blocks convention-based package discovery.

## solution

Enforce strict naming conventions: router file must match package name.

**Convention:** For package `ish-{name}`, router must be `source/{name}.sh`

## subtasks

- [ ] Rename `packages/ish-ratfiles/source/dotfiles.sh` → `source/ratfiles.sh`
- [ ] Update `core/bin/ish` line ~69: change `dotfiles.sh` → `ratfiles.sh`
- [ ] Search for any test references to `dotfiles.sh` and update
- [ ] Run test suite to verify: `./ish test all` (98/98 passing)
- [ ] Verify commands still work: `./ish ratfiles help`

## deliverable

Consistent naming throughout ish-ratfiles package following conventions.

## critical files

- `packages/ish-ratfiles/source/dotfiles.sh` → RENAME to `ratfiles.sh`
- `core/bin/ish` - UPDATE hardcoded source path
- Test files - UPDATE any references (grep for "dotfiles.sh")

## verification

```bash
# File renamed
ls packages/ish-ratfiles/source/ratfiles.sh  # Should exist
ls packages/ish-ratfiles/source/dotfiles.sh  # Should not exist

# Commands work
./ish ratfiles help
./ish ratfiles bootstrap help

# Tests pass
./ish test all  # 98/98
```

## notes

This task unblocks `implement-package-discovery` which requires consistent naming conventions.
