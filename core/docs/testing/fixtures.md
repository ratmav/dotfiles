# fixtures

## fixture helpers

fixtures create controlled, predictable state for testing logic in isolation.

- unit tests test logic with controlled state (fixtures)
- integration tests test cli composition with controlled state (fixtures)
- both use fixtures to ensure deterministic, repeatable results
- baseline checks test consistent system state (bash, platform) and are explicitly marked

**available helpers** (create fake executables and files in `/tmp/ish_fixtures`):

- `fixture_executable <name>` — creates executable, prepends to path
- `fixture_file <name>` — creates file
- `fixture_cleanup` — removes all fixtures and cleans path
- `fixture_kanban_task_create` — creates test task at `test/fixtures/kanban/tasks/test-task.md`
- `fixture_kanban_task_destroy` — removes test task

```bash
setup() {
  load '../test_helper/common-setup'
  _common_setup
  load '../test_helper/fixtures'
}

teardown() {
  fixture_cleanup
}

@test "ish_exists_executable detects fixture" {
  fixture_executable mycommand_test_bin
  assert ish_exists_executable mycommand_test_bin
}
```

fixtures create exactly the name you specify — no magic suffixes. use explicit suffixes in tests (e.g., `mycommand_test_bin`) to make it obvious these are test fixtures.

## ISH_TESTING environment variable

when `ISH_TESTING=true`, modules use test fixtures instead of production data:
- kanban commands use `test/fixtures/kanban/` instead of `kanban/`
- future modules can check this flag for test-specific behavior
- single flag controls all test isolation

**pattern in module code:**
```bash
ish_kanban_show() {
  local kanban_dir

  if [[ "${ISH_TESTING:-false}" == "true" ]]; then
    kanban_dir="${ish_kanban_module_dir}/test/fixtures/kanban"
  else
    kanban_dir="${ish_kanban_module_dir}/kanban"
  fi

  cat "$kanban_dir/board.md"
}
```

**pattern in tests:**
```bash
setup() {
  load '../test_helper/common-setup'
  _common_setup
  export ISH_TESTING=true
}

@test "ish kanban show uses test fixtures" {
  run ./ish kanban show
  assert_success
}
```

## when to use fixtures

- testing function logic with known inputs (unit tests)
- testing cli behavior with controlled state (integration tests)
- testing idempotency (simulate "already installed")
- testing file existence checks with known state
- ensuring deterministic test results across environments

## no skipped tests

**we don't skip tests.** a skipped test is a bug.

if a test can't run:
1. **use fixtures** to simulate the required state
2. **remove the test** if it's fundamentally untestable
3. **fix the underlying issue** that prevents testing

skipped tests are technical debt that never gets paid.
