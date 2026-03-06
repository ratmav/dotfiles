# extract integrations to top-level directory

**dependencies:** none

**priority:** high (blocks sqlite cleanup and phase 5 integrations)

## context

integrations (git, sqlite) wrap external binaries but live inside `core/source/`. core is pure bash (foundation + primitives). these are fundamentally different — sharing a directory hides a real dependency. extracting to `integrations/` makes the dependency direction explicit (`${ISH_CORE}/source/stream.sh` instead of `${module_dir}/stream.sh`). phase 5 adds curl/ssh/jq — they should land in the right place from the start.

## subtasks

- [ ] create `integrations/` directory structure (source/, test/unit/, test/integration/, test/test_helper/)
- [ ] add bats submodules pinned to same commits as core/packages
- [ ] copy test_helper files (common-setup.bash, fixtures.bash)
- [ ] move git.sh + git/ and sqlite.sh + sqlite/ from core/source/ to integrations/source/
- [ ] update routers to source foundations via `${ISH_CORE}/source/` instead of `${module_dir}/`
- [ ] add `ISH_INTEGRATIONS` to core/bin/ish
- [ ] move git and sqlite test files from core/test/unit/ to integrations/test/unit/
- [ ] update test files to source via `${ISH_INTEGRATIONS}`
- [ ] update test runner (core/source/test.sh) to scan integrations test dirs
- [ ] update core/docs/architecture/layers.md paths
- [ ] update kanban tasks (build-fp-core-git.md, split-fp-core-sqlite.md)
- [ ] run all tests, verify passing

## deliverable

`integrations/` as a top-level directory with git and sqlite source + tests. core contains only foundation and primitives. dependency direction is explicit.
