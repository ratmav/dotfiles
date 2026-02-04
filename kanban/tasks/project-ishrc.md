# 004: per-project task definitions via .ishrc

**milestone:** 2 - remote execution

**dependencies:** phase 2 task 003 (understand project patterns from battle-testing)

## description

auto-load `.ishrc` file in current directory to define project-specific commands. enforces namespace to prevent collisions.

## subtasks

- [ ] implement .ishrc auto-loading (like direnv loads .envrc)
- [ ] define namespace enforcement: functions must be prefixed with parent directory name
  - in `/foo/myproject/`, functions must start with `myproject_`
  - example: `myproject_deploy()`, `myproject_test()`
- [ ] refuse to load .ishrc if functions don't follow convention
- [ ] test with multiple projects to verify namespace isolation
- [ ] document pattern in conventions.md

## deliverable

`ish project <command>` sources local .ishrc with namespace validation

## notes

prevents namespace collisions between projects and core ish commands
