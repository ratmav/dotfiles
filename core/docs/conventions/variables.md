# variables and error handling

## local variables

**all local variables must be declared at the top of the function.**

```bash
foo_bar_action() {
  local required_arg="${1:-}"
  local optional_arg="${2:-default}"
  local computed_var
  local result

  # function body
  computed_var=$(some_command)
  result=$(another_command)

  echo "$result"
}
```

**rules:**
- declare all locals immediately after function opening brace
- assign immediately if value is available (`local var="${1}"`)
- declare without assignment if value computed later (`local result`)
- never declare locals in the middle of function body
- group related locals together (args first, then computed values)

**benefits:**
- function dependencies visible at a glance
- prevents accidental global variable pollution
- makes variable scope explicit
- follows standard bash best practices

## error handling

### fail fast principle

**errors are fatal. warnings are not.**

```bash
ish_tui_error --message="text"  # exits immediately with code 1
ish_tui_warn --message="text"   # continues execution
ish_tui_info --message="text"   # continues execution
```

**`ish_tui_error` semantics:**
- prints error message to stderr
- exits immediately with code 1
- no need for `return 1` or `exit 1` after calling it
- use for unrecoverable errors (missing dependencies, invalid state)

**`ish_tui_warn` semantics:**
- prints warning message to stderr
- continues execution
- use for recoverable issues (already installed, skipping optional step)

**pattern in routing functions:**
```bash
case "${1-}" in
  action)
    foo_bar_action
    ;;
  *)
    foo_help                                      # show help first
    ish_tui_error --message="unknown command"     # then fail fast
    ;;
esac
```

**other conventions:**
- use `set -eeuo pipefail` in entry points
- use `${1-}` instead of `$1` to handle empty args
