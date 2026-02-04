# 001: create scaffolding commands

**milestone:** 1 - local experience

**dependencies:** none

## description

make contributing to ish easier by generating module boilerplate with the mirroring principle - parallel structure in test directories.

## subtasks

- [ ] design `ish new foo/bar/baz` command syntax
- [ ] create templating utility for generating files from templates
- [ ] design templates following all conventions (naming, structure, routing)
- [ ] implement module generation at bash/foo/bar/baz.sh
- [ ] implement parallel test structure generation:
  - test/unit/foo/bar/baz.bats (unit tests, if testable logic)
  - test/integration/foo/bar/baz.bats (integration tests)
- [ ] handle existing nested directories
- [ ] handle new top-level modules
- [ ] document scaffolding usage

## deliverable

`ish new` generates source + tests in mirrored structure

## notes

**mirroring principle:** source and test directories mirror each other
missing test file = untestable (modifies system state) or not yet implemented
