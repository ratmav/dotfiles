# testing conventions

## tests first: specs as documentation

**write failing tests before implementation.**

tests are not just verification - they are executable specifications that document behavior at both unit and integration levels.

**why tests first:**

1. **tests are specifications**
   - unit tests document function behavior: inputs, outputs, edge cases
   - integration tests document cross-module and cli behavior
   - the test suite is the most accurate documentation (it must pass to ship)

2. **tests are living documentation**
   - always up to date (outdated tests fail)
   - shows actual usage patterns, not idealized examples
   - new contributors read tests to understand how things work

3. **tests drive design**
   - writing tests first reveals api awkwardness before implementation
   - forces thinking about edge cases up front
   - prevents overengineering (only implement what tests require)

4. **tests enable refactoring**
   - change implementation freely, tests verify behavior preserved
   - confidence to improve code without breaking functionality

**the pattern:**

```bash
# 1. write failing test (documents desired behavior)
@test "ish foo bar outputs expected result" {
  run ./ish foo bar --option=value
  assert_success
  assert_output --partial "expected"
}

# 2. run test (verify it fails)
# 3. implement minimal code to pass
# 4. run test (verify it passes)
```

**levels of testing:**

- **unit tests** (`test/unit/`) - test individual functions in isolation
  - document function contracts (inputs → outputs)
  - test edge cases and error conditions
  - use fixtures to control dependencies

- **integration tests** (`test/integration/`) - test cross-module interactions
  - cli is the most common place this happens, but not the only one
  - any test that exercises code paths spanning multiple modules
  - verify help text, error messages, exit codes

**when writing tests:**
- start with integration test (document cross-module behavior)
- add unit tests for complex logic or edge cases
- test error paths, not just happy paths
- use fixtures to make tests deterministic

## fixture pattern for deterministic tests

use fixtures to simulate external state instead of relying on environment-specific conditions.

```bash
setup() {
  load '../test_helper/common-setup'
  _common_setup
  load '../test_helper/fixtures'
}

teardown() {
  fixture_cleanup
}

@test "foo bar is idempotent" {
  fixture_executable baz  # creates fake baz in path

  run ./ish foo bar
  assert_success
  assert_output --partial "already installed"
}
```

**fixture helpers:**
- `fixture_executable <name>` - creates fake executable, prepends to path
- `fixture_file <name>` - creates fake file
- `fixture_cleanup` - removes fixtures and cleans path

**benefits:**
- tests run deterministically across all environments
- no dependency on actual installed software
- tests actual code paths (not mocking internals)

## no skipped tests

**we don't skip tests.** a skipped test is a bug.

if a test can't run:
1. use fixtures to create the required state
2. remove the test if fundamentally untestable
3. fix the underlying issue

skipped tests accumulate as technical debt that never gets paid.
