# writing tests

## test file structure

```bash
#!/usr/bin/env bats

# runs once before all tests in this file
setup_file() {
  # optional: file-level setup
}

# runs before each test
setup() {
  load '../test_helper/common-setup'  # adjust path based on location
  _common_setup

  # source files needed for testing (unit tests only)
  source source/utils.sh
}

# individual test
@test "descriptive test name" {
  assert command_that_should_succeed
  refute command_that_should_fail
}

# runs after each test
teardown() {
  # optional: per-test cleanup
}

# runs once after all tests in this file
teardown_file() {
  # optional: file-level cleanup
  rm -f /tmp/ish_test_*
}
```

## naming conventions

**unit test files:** mirror the source file path exactly
- `source/platform.sh` → `test/unit/platform.bats`
- `source/tui.sh` → `test/unit/tui.bats`
- `source/utils/exists.sh` → `test/unit/utils/exists.bats`
- same directory structure, same filename (.bats instead of .sh)

**integration test files:** mirror the cli command structure
- `./ish platform` → `test/integration/platform.bats`
- `./ish utils exists` → `test/integration/utils/exists.bats`
- same nesting structure, command becomes directory or file name

**test names:** describe what the test validates in plain language
- good: `"ish_exists_executable detects installed commands"`
- good: `"ish platform with invalid command shows error"`
- bad: `"test 1"`, `"it works"`

## common assertions

```bash
# command success/failure
assert command           # assert command succeeds (exit 0)
refute command          # assert command fails (exit non-zero)

# with run helper (captures output)
run ./ish platform os
assert_success          # assert exit code 0
assert_failure          # assert exit code non-zero
assert_output "kali"    # assert exact output match
assert_output --partial "usage:"  # assert substring match
assert_output --regexp "^(macos|kali)$"  # assert regex match

# inversions
refute_output "unexpected"
```

see [bats-assert documentation](https://github.com/bats-core/bats-assert) for more assertions.

**running tests recursively:**
- use `--recursive` flag to find tests in subdirectories
- all ish test commands use `--recursive` automatically

## adding new tests

**for a new module:**
1. create unit test file: `test/unit/module_name.bats`
2. source the module in `setup()`
3. test each public function
4. use `assert` for positive cases, `refute` for negative cases

**for new cli commands:**
1. add tests to existing integration file or create new one
2. use `run ./ish command subcommand` to invoke cli
3. test success cases, error cases, and help text
4. verify idempotency where applicable
