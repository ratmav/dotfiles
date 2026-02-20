# create scaffolding commands

**phase:** 6

**dependencies:** implement-registry

## description

make contributing to ish easier by generating package boilerplate with the mirroring principle — parallel structure in test directories.

## subtasks

- [ ] implement `ish package scaffold --name=NAME` (see `registry_commands.md`)
- [ ] create templating utility for generating files from templates
- [ ] design templates following all conventions (naming, structure, routing)
- [ ] generate standard package structure:
  - `packages/ish-<name>/source/<name>.sh` (package router)
  - `packages/ish-<name>/test/unit/` and `test/integration/`
  - `packages/ish-<name>/docs/`
  - `packages/ish-<name>/data/`
- [ ] handle bats submodule setup in test infrastructure
- [ ] document scaffolding usage

## deliverable

`ish package scaffold` generates a working package with source, tests, docs, and data.

## notes

**mirroring principle:** source and test directories mirror each other.
missing test file = untestable (modifies system state) or not yet implemented.
