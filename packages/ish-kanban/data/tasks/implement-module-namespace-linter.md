# implement module namespace linter

**phase:** 2

**dependencies:** none

## description

build static analysis to detect module_dir namespace violations and enforce DAG architecture conventions.

reference: `core/docs/vision/static_analysis.md`

## subtasks

**namespace validation:**
- [ ] detect bare `module_dir=` declarations (should be `*_module_dir`)
- [ ] verify module_dir naming matches file path
- [ ] flag collisions when modules source each other

**DAG validation:**
- [ ] parse source statements to build dependency graph
- [ ] detect circular dependencies
- [ ] verify directory structure matches dependency flow
- [ ] enforce: only source peers or children, never parents

**function naming validation:**
- [ ] verify functions match file path (`core/source/foo/bar.sh` -> `ish_foo_bar_*`)
- [ ] detect functions in wrong files
- [ ] enforce package prefix consistency (`ish_ratfiles_*` in `ish-ratfiles` package)

**implementation approach:**
- [ ] research shellcheck extensibility (can we plugin?)
- [ ] if yes: write custom shellcheck rules
- [ ] if no: build standalone bash AST analyzer or fork shellcheck
- [ ] integrate into `ish lint` command
- [ ] consider: new purpose-built language for shell linting (port shellcheck's analysis to a language designed for this domain)

## deliverable

static analysis catches namespace and DAG violations at lint time.

## critical files

- `core/source/lint/namespace.sh` (NEW - namespace checks)
- `core/source/lint/dag.sh` (NEW - DAG validation)
- `core/source/lint.sh` (UPDATE - integrate new checks)

## verification

```bash
# catch bare module_dir
echo 'module_dir=/foo' > test.sh
./ish lint test.sh
# (should fail with error about unnamespaced module_dir)

# catch circular dependency
# (create two files that source each other)
./ish lint core/source/
# (should detect and report cycle)
```
