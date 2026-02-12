# refactor help to templates

**milestone:** 1 - restructure

**dependencies:** implement-package-discovery (complete)

## problem

Help text is currently embedded in heredocs throughout the codebase. This makes it:
- Harder to maintain and update
- Inconsistent in formatting
- Difficult to add dynamic content
- Not leveraging existing tui template infrastructure

## solution

Refactor all help heredocs to use template-based approach:

1. Create `templates.sh` module in each package (core and ish-ratfiles)
2. Move help heredocs into template files or functions
3. Use `ish_utils_tui_template` functions for rendering
4. Support both static templates (no substitution) and dynamic templates (with variable substitution)

## subtasks

### Phase 1: Infrastructure
- [ ] Create `core/source/templates.sh` module
- [ ] Create `packages/ish-ratfiles/source/templates.sh` module
- [ ] Define template storage strategy (inline functions vs separate files)

### Phase 2: Core Package
- [ ] Refactor `ish_help()` in `core/bin/ish` to use templates
- [ ] Refactor `ish_kanban_help()` to use templates
- [ ] Refactor `ish_utils_help()` to use templates
- [ ] Refactor `ish_tui_help()` to use templates
- [ ] Refactor other core help functions

### Phase 3: Ratfiles Package
- [ ] Refactor `ish_ratfiles_help()` to use templates
- [ ] Refactor `ish_ratfiles_bootstrap_help()` to use templates
- [ ] Refactor `ish_ratfiles_git_help()` to use templates
- [ ] Refactor `ish_ratfiles_nix_help()` to use templates

### Phase 4: Testing & Verification
- [ ] Verify all help commands still work
- [ ] Run full test suite to ensure no regressions
- [ ] Update any tests that check help output format

## deliverable

- Consistent template-based help system across all packages
- `templates.sh` module in core and ratfiles
- All help functions using `ish_utils_tui_template` infrastructure
- Clean separation between help logic and help content

## critical files

### New Files
- `core/source/templates.sh` - core package templates
- `packages/ish-ratfiles/source/templates.sh` - ratfiles package templates

### Modified Files
- `core/bin/ish` - refactor ish_help()
- `core/source/kanban.sh` - refactor help functions
- `core/source/utils.sh` - refactor help functions
- `core/source/utils/tui.sh` - refactor help functions
- `packages/ish-ratfiles/source/ratfiles.sh` - refactor help functions
- `packages/ish-ratfiles/source/bootstrap.sh` - refactor help functions
- `packages/ish-ratfiles/source/git.sh` - refactor help functions
- `packages/ish-ratfiles/source/nix.sh` - refactor help functions

## design decisions

**Template approach options:**
- **Option A**: Templates as functions (heredocs moved to template functions)
- **Option B**: Templates as separate files (require file I/O)

**Recommendation**: Option A for now - keep templates as functions but organized in templates.sh modules. This maintains simplicity while improving organization.

**Variable substitution:**
- Use `ish_utils_tui_template` for dynamic content (e.g., package lists)
- For static help, call template function directly without substitution

## verification

```bash
# Test all help commands
./ish help
./ish kanban help
./ish ratfiles help
./ish ratfiles bootstrap help
./ish ratfiles git help
./ish ratfiles nix help

# Run full test suite
./ish test all  # Should pass all 98 tests
```

## notes

This refactoring improves maintainability and sets foundation for:
- Dynamic help generation (already doing this for package discovery)
- Consistent formatting across all help text
- Easier help text updates and improvements
