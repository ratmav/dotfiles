# testing

ish uses [bats-core](https://github.com/bats-core/bats-core) for automated testing.

## requirements

- **bats-core 1.5.0+** - required for `run --keep-empty-lines` flag to preserve blank lines in output

## running tests

```bash
./ish self test all          # run all tests (unit + integration)
./ish self test unit         # run unit tests only
./ish self test integration  # run integration tests only
./ish self lint all          # run shellcheck on all bash files
```

## test organization

```
test/
├── bats/                    # bats-core test runner (git submodule)
├── test_helper/
│   ├── bats-support/        # test utilities (git submodule)
│   ├── bats-assert/         # assertion functions (git submodule)
│   └── common-setup.bash    # centralized library loader
├── unit/                    # module isolation tests (mirrors bash/ structure)
│   ├── platform.bats        # test bash/platform.sh
│   ├── tui.bats             # test bash/tui.sh
│   └── utils/
│       └── exists.bats      # test bash/utils/exists.sh
└── integration/             # cli functional tests (mirrors cli command structure)
    ├── platform.bats        # test ./ish platform
    ├── nix.bats             # test ./ish nix
    ├── utils.bats           # test ./ish utils (top-level)
    ├── utils/
    │   └── exists.bats      # test ./ish utils exists
    ├── bootstrap.bats       # test ./ish bootstrap (top-level)
    └── bootstrap/
        ├── macos.bats       # test ./ish bootstrap macos
        ├── posix.bats       # test ./ish bootstrap posix (routing)
        ├── posix/
        │   └── nix.bats     # test ./ish bootstrap posix nix
        └── kali.bats        # test ./ish bootstrap kali
```

**test structure mirrors source structure:**
- **unit tests** mirror source: bash/platform.sh → test/unit/platform.bats
- **integration tests** also mirror source: bash/bootstrap/posix/nix.sh → test/integration/bootstrap/posix/nix.bats
- both test types mirror implementation files (not cli commands)
- parallel structures make gaps visible and enable scaffolding tools
- missing test file = untestable (modifies system state) or not yet implemented

**test coverage philosophy:**
- core logic modules (platform, utils, tui) have unit tests
- infrastructure wrappers (git, self, nix, bootstrap) have integration tests only
- don't unit test wrappers around external tools (git commands, shellcheck, network apis)
- integration tests verify routing and composition, not duplicate unit coverage

## what to test

when adding new functionality, test these aspects:

**1. happy path:**
- function produces expected output
- message is written, file is created, command executes

**2. error conditions:**
- errors when required options missing (--message, --path, etc.)
- errors on unknown/invalid options
- errors on invalid input values
- error messages are clear and actionable

**3. edge cases:**
- empty inputs (when valid)
- special characters in inputs
- boundary conditions

**4. help text consistency:**
- help text matches actual command behavior
- all commands listed in help are implemented
- all required options documented
- format follows established pattern (options inline with commands)

**5. environment handling:**
- ISH_TESTING flag uses fixtures when true
- production paths used when false
- no hardcoded paths (use script_dir, module_dir)

**6. integration:**
- command works through full routing stack
- output format correct for piping/scripting
- exit codes correct (0 = success, 1 = error)

**checklist for new commands:**
```bash
# 1. happy path
@test "command does the thing"

# 2. required options
@test "command errors without required option"

# 3. unknown options
@test "command errors on unknown option"

# 4. help text
@test "help text matches implementation"

# 5. ISH_TESTING flag
@test "command uses fixtures in test mode"
```

**running tests recursively:**
- use `--recursive` flag to find tests in subdirectories
- example: `bats --recursive test/unit/`
- all ish test commands use `--recursive` automatically

### unit tests

unit tests exercise individual modules in isolation by sourcing bash files directly.

**characteristics:**
- fast execution
- test single functions
- direct function calls (no cli)
- isolated from external dependencies

**example:** `test/unit/utils.bats`
```bash
setup() {
  load '../test_helper/common-setup'
  _common_setup

  source bash/utils.sh
}

@test "utils_is_installed detects installed commands" {
  assert utils_is_installed bash
}

@test "utils_is_installed rejects nonexistent commands" {
  refute utils_is_installed fake_command_xyz
}
```

### integration tests

integration tests exercise the actual ish cli as users would invoke it.

**characteristics:**
- test real user workflows
- exercise full routing stack
- verify help text and error handling
- test idempotency of bootstrap operations

**example:** `test/integration/ish_platform.bats`
```bash
setup() {
  load '../test_helper/common-setup'
  _common_setup
}

@test "ish platform os succeeds" {
  run ./ish platform os
  assert_success
  assert_output --regexp "^(macos|kali)$"
}

@test "ish platform with invalid command shows error" {
  run ./ish platform invalid_command
  assert_failure
  assert_output --partial "unknown platform command"
}
```

## writing tests

### test file structure

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
  source bash/utils.sh
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

### naming conventions

**unit test files:** mirror the source file path exactly
- `bash/platform.sh` → `test/unit/platform.bats`
- `bash/tui.sh` → `test/unit/tui.bats`
- `bash/utils/exists.sh` → `test/unit/utils/exists.bats`
- the test path mirrors the source path: same directory structure, same filename (just .bats instead of .sh)

**integration test files:** mirror the cli command structure exactly
- test `./ish platform` → `test/integration/platform.bats`
- test `./ish bootstrap posix nix` → `test/integration/bootstrap/posix/nix.bats`
- test `./ish utils exists` → `test/integration/utils/exists.bats`
- the test path mirrors the cli path: same nesting structure, command becomes directory or file name

**test names:** describe what the test validates in plain language
- good: `"utils_is_installed detects installed commands"`
- good: `"ish platform with invalid command shows error"`
- bad: `"test 1"`
- bad: `"it works"`

### common assertions

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

### using fixtures

fixtures create controlled, predictable state for testing logic in isolation.

**philosophy:**
- unit tests test logic with controlled state (fixtures)
- integration tests test cli composition with controlled state (fixtures)
- both use fixtures to ensure deterministic, repeatable results
- baseline checks test consistent system state (bash, platform) and are explicitly marked

**fixture helpers** create fake executables and files in `/tmp/ish_fixtures`:

```bash
setup() {
  load '../test_helper/common-setup'
  _common_setup

  load '../test_helper/fixtures'
}

teardown() {
  fixture_cleanup
}

@test "utils_exists_executable detects fixture" {
  # create fixture with explicit _test_bin suffix for clarity
  fixture_executable mycommand_test_bin
  assert utils_exists_executable mycommand_test_bin
}

@test "ish bootstrap posix nix is idempotent" {
  # create fake nix executable in path
  fixture_executable nix_test_bin

  run ./ish bootstrap posix nix_test_bin
  assert_success
  assert_output --partial "already installed"
}
```

**available fixture helpers:**

- `fixture_executable <name>` - creates `/tmp/ish_fixtures/<name>` with executable bit, prepends to path
- `fixture_file <name>` - creates `/tmp/ish_fixtures/<name>`
- `fixture_cleanup` - removes all fixtures and cleans path
- `fixture_kanban_task_create` - creates dynamic test task at `test/fixtures/kanban/tasks/test-task.md`
- `fixture_kanban_task_destroy` - removes dynamic test task

**important:** fixtures create exactly the name you specify - no magic suffixes. use explicit suffixes in tests (e.g., `mycommand_test_bin`) to make it obvious these are test fixtures, not real commands or potential attack artifacts.

### ISH_TESTING environment variable

**test mode flag controls fixture behavior across all modules.**

when `ISH_TESTING=true` is set, modules use test fixtures instead of production data:
- kanban commands use `test/fixtures/kanban/` instead of `kanban/`
- future modules can check this flag for test-specific behavior
- single flag controls all test isolation

**pattern in module code:**
```bash
kanban_show() {
  local kanban_dir

  if [[ "${ISH_TESTING:-false}" == "true" ]]; then
    kanban_dir="${script_dir}/test/fixtures/kanban"
  else
    kanban_dir="${script_dir}/kanban"
  fi

  cat "$kanban_dir/board.md"
}
```

**pattern in tests:**
```bash
setup() {
  load '../test_helper/common-setup'
  _common_setup
  export ISH_TESTING=true  # enable test mode
}

@test "ish kanban show uses test fixtures" {
  run ./ish kanban show
  assert_success
  # tests against test/fixtures/kanban/board.md
}
```

**benefits:**
- single flag controls test isolation across all modules
- explicit test mode (no implicit magic)
- easy to extend to other modules
- production code unaffected (ISH_TESTING not set)

**when to use fixtures:**

- testing function logic with known inputs (unit tests)
- testing cli behavior with controlled state (integration tests)
- testing bootstrap idempotency (simulate "already installed")
- testing file existence checks with known state
- ensuring deterministic test results across environments

**baseline checks:** tests of consistent system state (bash exists, platform detection) are acceptable when explicitly marked. these validate the environment foundation rather than testing code logic.

### no skipped tests

**we don't skip tests.** a skipped test is a bug that needs fixing.

if a test can't run:
1. **use fixtures** to simulate the required state
2. **remove the test** if it's fundamentally untestable
3. **fix the underlying issue** that prevents testing

skipped tests are technical debt that never gets paid.

## adding new tests

### for a new module

1. create unit test file: `test/unit/module_name.bats`
2. source the module in `setup()`
3. test each public function
4. use `assert` for positive cases, `refute` for negative cases

### for new cli commands

1. add tests to existing integration file or create new one
2. use `run ./ish command subcommand` to invoke cli
3. test success cases, error cases, and help text
4. verify idempotency where applicable

## test philosophy

### what to test

**unit tests should verify:**
- functions return correct values
- functions handle empty/invalid input gracefully
- edge cases are handled properly

**integration tests should verify:**
- cli commands work end-to-end
- help text is present and useful
- error messages are clear
- invalid commands fail appropriately
- idempotent operations can be run multiple times safely

### what not to test

**don't test external tools or bash primitives:**
- external installers (homebrew, nix installers) - we can't control their behavior
- network operations - unreliable and slow
- standard bash commands (grep, mkdir, echo) - trust the shell
- file i/o primitives - if you're just testing that bash can write files, skip it

**don't duplicate coverage:**
- if a function is unit tested, don't retest it through cli routing
- integration tests verify routing + composition, not individual function logic
- example: `utils_exists_executable` has unit tests, so `./ish utils exists executable bash` just duplicates them

**don't test implementation details:**
- test behavior (what it does), not implementation (how it does it)
- test public apis, not internal helper functions
- example: test that config is detected as "already enabled", not the specific grep pattern used

**when in doubt, ask:**
- am i testing our code or bash/external tools?
- is this already covered by unit tests?
- would deleting this test leave a gap in coverage?
- if the answer is "no gap", delete the test

### test-driven development

when adding new features:

1. **write the test first** (it will fail)
2. **implement minimum code** to make it pass
3. **refactor** while keeping tests green
4. **add edge cases** as you discover them

**tdd benefits:**
- forces you to think about behavior before implementation
- ensures testability from the start
- prevents over-engineering (you stop when tests pass)
- documents intent through executable examples

**when to use tdd:**
- new utilities or abstractions
- bug fixes (write test that reproduces bug, then fix)
- refactoring critical code (tests verify behavior unchanged)

**when to skip tdd:**
- exploratory work (spike, then test)
- trivial changes (formatting, comments)
- work that doesn't need automated tests (docs, scripts)

when adding new utilities or commands:

1. write the test first (it will fail)
2. implement the minimum code to make it pass
3. refactor while keeping tests green
4. add edge case tests as you discover them

## troubleshooting

### tests fail with "command not found"

check that submodules are initialized:
```bash
git submodule update --init --recursive
```

### tests fail with path errors

verify `load` paths in tests match directory structure:
- from `test/unit/`: use `'../test_helper/common-setup'`
- from `test/integration/`: use `'../test_helper/common-setup'`
