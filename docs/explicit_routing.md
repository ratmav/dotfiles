# explicit routing pattern

## problem

bash positional parameters (`$1`, `$2`, etc.) are stateful and inherited when sourcing files.

**example of the issue:**
```bash
# user runs: ish bootstrap macos help
ish: $1="bootstrap", shifts to $1="macos"
  └─ sources macos.sh: inherits $1="macos", shifts to $1="help"
      ├─ sources tui.sh: inherits $1="help"
      │   └─ if case statement executes: matches "help", prints tui_help() ❌
      └─ macos.sh case: matches "help", prints bootstrap_macos_help() ✓
```

if `tui.sh` had an automatic case statement at the bottom, it would execute with inherited args, producing unwanted output.

## solution: explicit routing

separate function loading from command dispatching using explicit `_route()` functions.

**pattern:**
```bash
# bash/utils/tui.sh

# function definitions (pure, no side effects)
tui_info() { ... }
tui_warn() { ... }

# explicit routing function (only executes when called)
tui_route() {
  case "${1-}" in
    info) shift; tui_info "$@" ;;
    warn) shift; tui_warn "$@" ;;
    help|"") tui_help ;;
    *) tui_error "unknown command"; return 1 ;;
  esac
}
```

**usage:**
```bash
# in ish (cli entry point)
source bash/utils/tui.sh    # load functions
tui_route "$@"        # explicitly dispatch

# in other modules (just need functions)
source bash/utils/tui.sh    # load functions
tui_info "message"    # call directly, no routing
```

## benefits

1. **no side effects on source**: sourcing just loads function definitions
2. **cross-module safety**: modules can source each other without triggering routing logic
3. **explicit control**: caller decides when to route vs. call functions directly
4. **composability**: functions can be used standalone or via cli
5. **testability**: `ish tui info "test"` works by explicitly calling `tui_route`

## implementation checklist

for any module that needs cli exposure:

1. define functions (no automatic execution)
2. create `module_route()` function with case statement
3. document with: `# see docs/explicit_routing.md`
4. in `ish`, call `module_route "$@"` when routing to that module
5. other modules just source the file and call functions directly
