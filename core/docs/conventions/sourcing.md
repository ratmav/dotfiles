# sourcing dependencies

every file explicitly sources what it needs at the top of the file. always.

```bash
#!/usr/bin/env bash

foo_module_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source "${ISH_CORE}/source/tui.sh"
source "${foo_module_dir}/foo/bar.sh"
```

**rules:**
- all `source` statements at the top of the file, immediately after shebang and directory setup
- never source files conditionally
- never source files inside functions
- never wrap source calls in helper functions
- list dependencies in a logical order (utilities first, then domain modules)

**benefits:**
- self-documenting dependencies at a glance
- files can be tested in isolation
- no hidden coupling
- double-sourcing is safe (just redefines functions)

## environment variables

**all environment variables set by ish must be prefixed with `ISH_`**

this prevents namespace collisions with user/system environment variables.

**examples:**
```bash
ISH_TUI_ERROR='\033[0;31m'
ISH_TUI_CLEAR='\033[0m'
ISH_TEST_FIXTURES="/tmp/ish_fixtures"
```

**naming pattern:**
- `ISH_` prefix (required)
- module/subsystem identifier (`TUI_`, `TEST_`, etc.)
- specific variable name (`ERROR`, `FIXTURES`, etc.)

**rationale:**
- clear ownership - all ISH_* variables belong to ish
- avoids stomping user variables
- easy to grep for all ish environment state
- follows common practice (BATS_*, DOCKER_*, etc.)

### ISH_TESTING flag

**test mode flag enables fixture-based testing.**

`ISH_TESTING=true` signals modules to use test fixtures instead of production data:

```bash
foo_action() {
  local data_dir

  if [[ "${ISH_TESTING:-false}" == "true" ]]; then
    data_dir="${script_dir}/test/fixtures/foo"
  else
    data_dir="${script_dir}/foo"
  fi

  # use data_dir for operations
}
```

**guidelines:**
- check `ISH_TESTING` at function entry, set data paths accordingly
- default to `false` with `${ISH_TESTING:-false}` pattern
- only use for path/data switching, not logic changes
- never set ISH_TESTING in production code (tests only)
