# fix lint command

**milestone:** 1 - restructure

**dependencies:** standardize-package-naming (needs consistent naming for testing)

## description

The lint command has two issues:
1. **Redundant subcommand**: `ish lint bash` is the only real use case - should just be `ish lint`
2. **Broken globbing**: shellcheck receives literal `**/*.sh` instead of expanded file list

Current state forces users to type `ish lint bash` when `ish lint` would be clearer and more ergonomic.

## subtasks

- [ ] Simplify command structure: `ish lint` becomes primary command
- [ ] Fix globbing: use bash expansion before passing to shellcheck
- [ ] Add `ish` main script to lint target (currently in `ish_lint_all` only)
- [ ] Update help text to reflect simplified command
- [ ] Update any documentation referencing `ish lint bash`
- [ ] Verify: `ish lint` successfully lints all shell files

## deliverable

- `ish lint` works as primary command
- shellcheck properly lints all `.sh` files in packages/
- Clean help output
- Optional: keep `ish lint all` for explicit "lint everything including main ish script"

## critical files

- `core/source/lint.sh` - Main lint router
- `core/docs/conventions.md` - May reference lint commands

## verification

```bash
# Primary command works
ish lint

# Verify it actually lints files (should show any issues or "no problems")
# Not just the globbing error
ish lint 2>&1 | grep -v "does not exist"

# Help still works
ish lint help
```

## notes

**Design decision**: Keep `ish lint` simple. The "bash" distinction isn't meaningful since this is a bash project. If lua linting is needed later, it's already handled by Makefile.
