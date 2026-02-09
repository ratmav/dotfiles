# move docs to ish package

**milestone:** 1 - restructure

**parent task:** execute migration_path.md Step 1 (12-step restructure)

**dependencies:** package-local-bats.md (completed)

## description

Move documentation into the ish package. All current docs describe ish functionality, architecture, and conventions. As package-specific documentation, it should live at `packages/ish/docs/` not at repo root.

**Current state:**
```
docs/
├── philosophy.md
├── vision.md
├── explicit_routing.md
├── conventions.md
├── testing.md
└── architecture/
    ├── overview.md
    ├── migration_path.md
    ├── current_repo_restructure.md
    ├── package_types.md
    ├── task_reconciliation.md
    ├── core_concepts_and_data_structures.md
    ├── dependency_management.md
    ├── module_loading_system.md
    ├── registry_commands.md
    └── functional_future/
        ├── overview.md
        ├── state_management.md
        ├── just_use_curl.md
        └── fp_magic.md
```

**Target state:**
```
packages/ish/docs/
├── philosophy.md
├── vision.md
├── explicit_routing.md
├── conventions.md
├── testing.md
└── architecture/
    └── (all files remain the same)
```

**Why:** All documentation describes ish (core utility library). When ish moves to separate repo, docs move with it.

## subtasks

### 1. Move docs to ish package
- [ ] Move `docs/` → `packages/ish/docs/`

### 2. Update internal doc references
- [ ] Search for relative links to docs (grep for `../` and `docs/` in markdown files)
- [ ] Update paths in markdown files to reflect new location
- [ ] Check for hardcoded doc paths in code comments

### 3. Verify accessibility
- [ ] Verify all moved docs render correctly
- [ ] Check internal links between docs still work
- [ ] Confirm no broken references in code

## deliverable

All documentation lives at `packages/ish/docs/`. No docs/ directory at repo root.

## critical files

- `docs/` → `packages/ish/docs/` - MOVE (entire directory)

## benefits

1. **Package independence**: Docs move with ish when repos split
2. **Clarity**: All ish-related content in ish package
3. **Simplicity**: No ambiguity about where docs live
4. **Consistency**: Follows package structure established in package_types.md
