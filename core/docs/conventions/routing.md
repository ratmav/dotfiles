# routing

## why explicit routing

bash positional parameters (`$1`, `$2`, etc.) are inherited when sourcing files. if a sourced file has a case statement at file scope, it executes with the caller's args — producing unwanted output.

```bash
# user runs: ish bootstrap macos help
ish: $1="bootstrap", shifts to $1="macos"
  └─ sources macos.sh: inherits $1="macos", shifts to $1="help"
      ├─ sources tui.sh: inherits $1="help"
      │   └─ file-scope case matches "help", prints tui help ✗
      └─ macos case matches "help", prints macos help ✓
```

**solution:** separate function loading from command dispatching. sourcing loads definitions only. routing is explicit via `*_route()` functions that callers invoke deliberately.

## routing pattern

every routable module (exposed via cli) has:

1. **function definitions** at the top
2. **`module_all()`** wrapper function for complete workflows (if module supports "all")
3. **`module_help()`** function describing commands
4. **`module_route()`** function with case statement for dispatching

### the `*_all()` wrapper pattern

when a module has an "all" command that runs multiple steps, create a dedicated `*_all()` function:

```bash
# source/foo.sh
foo_all() {
  foo_bar_install
  foo_bar_configure
  foo_baz_setup
}

foo_route() {
  case "${1-}" in
    all)
      foo_all  # router just calls wrapper
      ;;
    # ...
  esac
}
```

**benefits:**
- encapsulates complete workflow in a single callable function
- router stays clean and simple
- easy to test: call `foo_all` directly
- workflow dependencies are explicit and documented
- callers don't need to know internal step ordering

**when to call router vs all function:**

call the **router** (`*_route()`) when:
- dispatching cli commands with user input
- you need to handle multiple subcommands

call the **all function** (`*_all()`) when:
- you want to programmatically run the complete workflow
- you're composing larger workflows from smaller ones
- example: `foo_all()` calls `foo_bar_all()` directly

**rule of thumb:** if you know exactly what you want to execute, call the function directly. if you're routing user input, use the router.

## help text format

```bash
foo_help() {
  echo "usage: ish foo [command]"
  echo ""
  echo "commands:"
  echo "  all          run all foo functions"
  echo "  command1     description"
  echo "  command2     description"
}
```

- lowercase
- aligned columns
- brief descriptions
- `all` listed first if applicable
