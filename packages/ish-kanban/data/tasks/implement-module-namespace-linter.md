# implement module namespace linter

**milestone:** 2 - fp core + cleanup

**dependencies:** standardize-package-naming, implement-package-loading-strategy

## description

Build static analysis to detect module_dir namespace violations and enforce DAG architecture conventions.

Reference: vision.md lines 353-429 describes custom shellcheck rules

## subtasks

**Namespace validation:**
- [ ] Detect bare `module_dir=` declarations (should be `*_module_dir`)
- [ ] Verify module_dir naming matches file path
- [ ] Flag collisions when modules source each other

**DAG validation:**
- [ ] Parse source statements to build dependency graph
- [ ] Detect circular dependencies
- [ ] Verify directory structure matches dependency flow
- [ ] Enforce: only source peers or children, never parents

**Function naming validation:**
- [ ] Verify functions match file path (bash/foo/bar.sh → foo_bar_*)
- [ ] Detect functions in wrong files
- [ ] Enforce package prefix consistency (ish_dotfiles_* in ish-dotfiles package)

**Implementation approach:**
- [ ] Research shellcheck extensibility (can we plugin?)
- [ ] If yes: write custom shellcheck rules
- [ ] If no: build standalone bash AST analyzer or fork shellcheck
- [ ] Integrate into `ish lint` command

**CI integration:**
- [ ] Add to lint task in phase 1
- [ ] Run on all PRs
- [ ] Fail on violations

## deliverable

Static analysis catches namespace and DAG violations at lint time.

## critical files

- `packages/ish/source/lint/namespace.sh` (NEW - namespace checks)
- `packages/ish/source/lint/dag.sh` (NEW - DAG validation)
- `packages/ish/source/lint.sh` (UPDATE - integrate new checks)

## verification

```bash
# Catch bare module_dir
echo 'module_dir=/foo' > test.sh
./ish lint test.sh
# (should fail with error about unnamespaced module_dir)

# Catch circular dependency
# (create two files that source each other)
./ish lint packages/ish/source/
# (should detect and report cycle)
```
