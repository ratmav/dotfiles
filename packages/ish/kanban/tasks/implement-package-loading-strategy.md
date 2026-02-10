# implement package loading strategy

**milestone:** 1 - restructure

**dependencies:** standardize-package-naming (MUST complete first)

## description

Define and implement how ish loads packages so that ish_core_* functions are available to all packages, and packages can use each other's functions safely.

## requirements

**Loading order:**
1. ish core functions (ish_core_*)
2. ish package functions (ish_kanban_*, ish_utils_*, etc.)
3. ish-dotfiles package functions (ish_dotfiles_*)
4. Future: other packages

**Package discovery:**
- Scan `packages/` directory
- Load packages in dependency order
- Detect circular dependencies (fail fast)

**Namespace isolation:**
- Each package sources its dependencies explicitly
- No global namespace pollution
- Clear dependency graph

## subtasks

- [ ] Design package loading order (document in architecture/)
- [ ] Implement package scanner in main ish entry point
- [ ] Load ish core first (ish_core_* available to all)
- [ ] Load ish package second (ish_* functions)
- [ ] Load ish-dotfiles third (can use ish_core_* and ish_*)
- [ ] Test: verify ish_core_* available in dotfiles functions
- [ ] Test: verify no circular dependencies
- [ ] Document loading strategy in conventions.md

## deliverable

Packages load in correct order. ish_core_* functions available to all packages. Clear dependency graph.

## critical files

- `ish` (main entry point - package loading logic)
- `packages/ish/docs/architecture/package_loading.md` (NEW - design doc)
- `packages/ish/docs/conventions.md` (UPDATE - loading conventions)

## verification

```bash
# ish-dotfiles can call ish_core_* functions
grep "ish_core_" packages/ish-dotfiles/source/**/*.sh
# (should find uses of ish_core_stream_*, etc.)

# No circular dependencies
# (loading should succeed without errors)
./ish help
```
