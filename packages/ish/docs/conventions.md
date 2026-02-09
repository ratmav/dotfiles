# code conventions

## core design principles

### live off the land

**cannibalize the host. work with what you have to get what you want.**

ish is designed to require minimal external dependencies and use tools already present on the target system.

**requirements:**
- bash (already on all posix systems)
- ssh (for remote execution)
- standard posix utilities (grep, awk, sed, etc.)

**no requirements for:**
- python/ruby/node interpreters
- package managers to be pre-installed
- external configuration files
- network connectivity (beyond initial setup)

**why this matters:**
- works on fresh systems out of the box
- can bootstrap itself from nothing
- portable across any posix platform
- viable ansible replacement without python dependency
- single file can be copied and executed immediately

**in practice:**
- check if tools exist before trying to install them
- use built-in bash features over external commands when possible
- bootstrap idempotently - safe to run multiple times
- self-contained - ish brings everything it needs

## function naming

functions map to file paths via naming convention:

```
function: bootstrap_posix_nix_install
file:     bash/bootstrap/posix/nix.sh
```

**pattern:** `module_submodule_action()`

**rules:**
- underscores separate hierarchy levels
- function prefix must match directory path
- action is the last component (install, configure, help, etc.)
- private helper functions start with `_` and are not registered in routing

### public vs private functions

**public functions:**
- exposed via cli routing in `*_route()` functions
- listed in `*_help()` output
- used by other modules as the public api
- placed at top of file, alphabetized

**private functions:**
- start with underscore prefix: `_platform_is_macos()`
- not registered in routing functions
- not listed in help text
- used only internally within the same file
- can be called by other files that source the module, but shouldn't be (underscore = "don't use this")
- placed at bottom of file after routing function, alphabetized

**file structure:**
```bash
#!/usr/bin/env bash

# public functions (alphabetized)
module_command_one() { ... }
module_command_two() { ... }
module_help() { ... }
module_route() { ... }

# private functions (alphabetized)
_module_helper_one() { ... }
_module_helper_two() { ... }
```

**example from bash/platform.sh:**
```bash
# public functions (alphabetized)
platform_arch() { ... }
platform_os() {
  if _platform_is_macos; then    # uses private helper
    echo "macos"
  elif _platform_is_kali; then   # uses private helper
    echo "kali"
  else
    echo "linux"
  fi
}

# private functions (alphabetized)
_platform_is_kali() { ... }
_platform_is_macos() { ... }
```

**usage in other files:**
```bash
source "${script_dir}/bash/platform.sh"

# ✓ use public api
if [[ $(platform_os) == "macos" ]]; then
  # do macos stuff
fi

# ✗ don't use private functions
# if _platform_is_macos; then  # don't do this!
```

## file organization

### directory structure

```
bash/
  tui.sh              # terminal ui utilities
  platform.sh         # platform detection
  git.sh              # git router + functions
  bootstrap/
    macos.sh          # macos router
    macos/
      homebrew.sh     # homebrew functions
      bash.sh         # bash configuration functions
    kali.sh           # kali router
    posix.sh          # posix router
    posix/
      nix.sh          # nix functions
      nvim.sh         # neovim functions
  legacy/             # deprecated code kept as reference
```

### the growth pattern: from router to module

start simple and grow organically:

**stage 1: functions in router file**
```bash
# bash/git.sh
git_prune_sync() { ... }
git_worktree_cleanup() { ... }

git_route() {
  case "${1-}" in
    prune)
      shift
      case "${1-}" in
        sync) git_prune_sync "$@" ;;
      esac
      ;;
    worktree)
      shift
      case "${1-}" in
        cleanup) git_worktree_cleanup "$@" ;;
      esac
      ;;
  esac
}
```

**stage 2: extract when grouping becomes clear**

if you add more `git_prune_*` functions, extract to a module:
```bash
# bash/git/prune.sh
git_prune_sync() { ... }
git_prune_local() { ... }
git_prune_stale() { ... }

# bash/git.sh (router sources and delegates)
source "${script_dir}/bash/git/prune.sh"

git_route() {
  case "${1-}" in
    prune)
      shift
      case "${1-}" in
        sync) git_prune_sync "$@" ;;
        local) git_prune_local "$@" ;;
        stale) git_prune_stale "$@" ;;
      esac
      ;;
  esac
}
```

**stage 3: create sub-router when crossing directory boundary**

if `prune` gets complex enough to need subdirectories:
```bash
# bash/git/prune.sh (becomes a router)
source "${script_dir}/bash/git/prune/remote.sh"
source "${script_dir}/bash/git/prune/local.sh"

git_prune_route() {
  case "${1-}" in
    sync) git_prune_sync "$@" ;;
    remote) shift; git_prune_remote_route "$@" ;;
    local) shift; git_prune_local_route "$@" ;;
  esac
}

# bash/git.sh
source "${script_dir}/bash/git/prune.sh"

git_route() {
  case "${1-}" in
    prune) shift; git_prune_route "$@" ;;
  esac
}
```

**key principles:**
- start with functions in the router file
- extract to modules when logical grouping emerges (2+ related functions)
- functions group by **longest common prefix** (lowest common denominator)
- create sub-routers only when crossing directory boundaries
- each directory level has one router file that sources and delegates

### when to create subdirectories

create a subdirectory when:
- **2+ functions share a common prefix** beyond the module name
  - example: `git_prune_sync`, `git_prune_local` → create `bash/git/prune.sh`
  - repetition is jarring; address it immediately
- **logical grouping is clear** based on functionality
  - example: all homebrew operations → `bash/bootstrap/macos/homebrew.sh`
- **file gets long (>150 lines)** → split by functional groups

keep in parent file when:
- **single function** for a concept
- **unclear grouping** - wait until the pattern emerges (but once you have 2, extract)

## routing pattern

every routable module (exposed via cli) has:

1. **function definitions** at the top
2. **`module_all()`** wrapper function for complete workflows (if module supports "all")
3. **`module_help()`** function describing commands
4. **`module_route()`** function with case statement for dispatching

see `docs/explicit_routing.md` for detailed explanation.

### the `*_all()` wrapper pattern

when a module has an "all" command that runs multiple steps, create a dedicated `*_all()` function:

```bash
# bash/bootstrap/macos.sh
bootstrap_macos_all() {
  # platform-specific steps
  bootstrap_macos_homebrew_install
  bootstrap_macos_homebrew_brew
  bootstrap_macos_homebrew_cask
  bootstrap_macos_bash

  # shared/dependency steps
  bootstrap_posix_all
}

bootstrap_macos_route() {
  case "${1-}" in
    all)
      bootstrap_macos_all  # router just calls wrapper
      ;;
    # ...
  esac
}
```

**benefits:**
- encapsulates complete workflow in a single callable function
- router stays clean and simple
- easy to test: call `bootstrap_macos_all` directly
- workflow dependencies are explicit and documented
- callers don't need to know internal step ordering

**when to call router vs all function:**

call the **router** (`*_route()`) when:
- dispatching cli commands with user input
- you need to handle multiple subcommands
- example: `bootstrap_macos_route "$@"` in main ish file

call the **all function** (`*_all()`) when:
- you want to programmatically run the complete workflow
- you're composing larger workflows from smaller ones
- example: `bootstrap_macos_all()` calls `bootstrap_posix_all()` directly
- example: `ish bootstrap all` detects platform and calls `bootstrap_macos_all()` directly

**rule of thumb:** if you know exactly what you want to execute, call the function directly. if you're routing user input, use the router.

## cli structure

### routing grammar

```
ish [command] [subcommand] [subcommand] [subcommand...]
```

we chain **single-word subcommands** to navigate the module hierarchy.

**rules:**
- each level is a **single word** (not kebab-case, not multi-word)
- commands narrow scope **left to right**
- no args = show help
- `all` keyword = run all functions in that module
- `help` works at every level
- consistent across all modules

**left-to-right scope narrowing:**

each word narrows the scope of what we're doing:

```bash
ish                         # top level: ish cli wrapper
ish git                     # git operations
ish git clean               # clean/remove cruft
ish git clean prune         # prune local branches missing on remote
```

the progression is always: **general → specific → action**

more examples:
```bash
ish bootstrap               # general: bootstrap operations
ish bootstrap macos         # specific: macos platform
ish bootstrap macos homebrew # more specific: homebrew package manager
ish bootstrap macos homebrew install # action: install it
```

**correct:**
```bash
ish bootstrap macos homebrew install    # ✓ four single-word subcommands
ish git prune sync                      # ✓ three single-word subcommands
ish platform os                         # ✓ two single-word subcommands
```

**incorrect:**
```bash
ish bootstrap macos homebrew-install    # ✗ kebab-case
ish git prune-sync                      # ✗ kebab-case
```

**function naming vs cli:**
- **cli**: single words separated by spaces → `ish git prune sync`
- **function**: underscores for the full path → `git_prune_sync()`
- underscores in function names are fine and expected

### avoiding kebab-case: function naming matters

kebab-case in cli commands (`ish utils is-installed`) is a symptom of poor function naming. the solution is to rethink the function hierarchy.

**anti-pattern: functions that don't map to single words**
```bash
# bad function names force kebab-case in cli
utils_is_installed()     → ish utils is-installed bash    # ✗ kebab-case
utils_file_exists()      → ish utils file-exists foo.txt  # ✗ kebab-case
```

**solution: add routing layer**
```bash
# good function names enable clean cli
utils_exists_executable()  → ish utils exists executable bash    # ✓ all single words
utils_exists_file()        → ish utils exists file foo.txt      # ✓ all single words
```

**the pattern:**
1. **identify the problem:** function name has multi-word concept (`is_installed`)
2. **extract the concept:** what category does this belong to? (`exists`)
3. **create subdirectory:** `bash/utils/exists.sh`
4. **rename functions:** `utils_exists_executable()`, `utils_exists_file()`
5. **add routing:** router at `bash/utils.sh` dispatches to `exists` subcommand

**structure:**
```
bash/
├── utils.sh              # router with utils_route()
└── utils/
    └── exists.sh         # implementation with utils_exists_*() functions
```

**result:**
- cli: `ish utils exists executable bash` - reads naturally, all single words
- function: `utils_exists_executable()` - follows naming convention
- extensible: can add `utils_exists_directory()` without refactoring

### hemingway over melville: brevity and clarity

**prefer brevity.** use the minimum levels needed for the current set of commands.

**anti-pattern: premature hierarchy**
```bash
# bad: 3 levels when you only have 1 command per group
ish git prune sync         # only one prune command exists
ish git worktree cleanup   # only one worktree command exists
```

**signal: overly specific commands**
if you have deeply nested commands but only one function at each level, you're creating structure before you need it. this is a design smell.

**solution: flatten until needed**
```bash
# good: 2 levels when you only have 1 command
ish git prune              # simple, clear (only one prune operation)
ish git cleanup-worktrees  # simple, clear (descriptive action)
```

**when to add hierarchy:**
- add a subcommand level when you have **2+ related commands** that need grouping
- single command? keep it flat
- repetition in names signals it's time to extract

**examples of good brevity:**
```bash
ish platform os            # 2 levels: direct, clear
ish tui info "message"     # 2 levels: simple utility
ish bootstrap macos all    # 3 levels: justified (many macos commands exist)
```

### options pattern

commands support `--flag=value` style options for clarity and extensibility.

**format:**
- equals-separated: `--message="text"` (required format)
- no space-separated: `--message "text"` (not supported)
- explicit `--` prefix for readability

**examples:**
```bash
ish tui info --message="build complete"
ish utils exists --executable=bash
ish utils exists --file=/etc/hosts
```

**implementation pattern:**

for single required option (most common case), use a private parsing helper:

```bash
# public function
utils_exists_file() {
  local path=$(_utils_parse_single_option "--file" "$@")
  [[ -f "$path" ]]
}

# private helper (at bottom of file)
_utils_parse_single_option() {
  local option_name=$1
  shift
  local value=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      "$option_name"=*)
        value="${1#*=}"
        shift
        ;;
      *)
        utils_tui_error --message="unknown option: $1"
        ;;
    esac
  done

  [[ -z "$value" ]] && utils_tui_error --message="$option_name required"

  echo "$value"
}
```

**special case: tui module**

tui functions parse options inline and use utils_stream_stderr directly to avoid circular dependencies:

```bash
utils_tui_info() {
  local message=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --message=*)
        message="${1#*=}"
        shift
        ;;
      *)
        utils_stream_stderr "${ISH_TUI_ERROR}unknown option: $1"
        exit 1
        ;;
    esac
  done

  if [[ -z "$message" ]]; then
    utils_stream_stderr "${ISH_TUI_ERROR}--message= required${ISH_TUI_CLEAR}"
    return 1
  fi

  utils_stream_stderr "${ISH_TUI_INFO}${message}${ISH_TUI_CLEAR}"
}
```

**guidelines:**
- inline option parsing when functions can't call utils_tui_error (circular dependency)
- use utils_stream_stderr directly for error messages within tui module
- use utils_tui_error for validation errors in all other modules

## help text format

```bash
module_help() {
  echo "usage: ish module [command]"
  echo ""
  echo "commands:"
  echo "  all          run all module functions"
  echo "  command1     description"
  echo "  command2     description"
}
```

- lowercase
- aligned columns
- brief descriptions
- `all` listed first if applicable

## dag architecture: the foundation

**the entire codebase is a directed acyclic graph (dag).**

this isn't just a nice property - it's the architectural foundation that makes everything else work.

### what is the dag?

nodes in the graph are modules (files). edges are dependencies (source statements).

```
bash/utils/tui.sh ──sources──> bash/utils/exists.sh
            ──sources──> bash/utils/tui/template.sh

bash/utils/tui/template.sh ──uses──> utils_tui_error (from parent)
                     ──uses──> utils_exists_file (parent sourced it)
```

**directed**: dependencies flow in one direction (parent → child, never child → parent)

**acyclic**: no circular dependencies - you cannot have a path from a module back to itself

### why dag structure?

**prevents circular dependencies by construction:**
- parent sources child
- child uses functions parent already loaded
- child cannot source parent (would violate directory hierarchy)
- impossible to create cycles if you follow conventions

**makes reasoning about code trivial:**
- dependency order is explicit (topological sort of the dag)
- no hidden coupling - all edges visible in source statements
- local changes have bounded impact (only descendants affected)
- can reason about any module in isolation (just trace its ancestors)

**enables safe refactoring:**
- change a function signature? grep for callers (they're descendants)
- extract a module? just update parent's source statements
- merge modules? combine source statements, preserve dag
- no surprises - the graph tells you what touches what

### directory structure enforces dag

the parent/child relationship in directories mirrors the dag structure:

```
bash/
├── tui.sh              # parent node
└── tui/
    └── template.sh     # child node

parent sources child. child uses parent's functions. acyclic by construction.
```

**rules enforced by structure:**
1. **parents source children** - `bash/utils/tui.sh` sources `bash/utils/tui/template.sh`
2. **children use parent functions** - `template.sh` calls `utils_tui_error` that parent defined
3. **siblings source shared dependencies** - both source `bash/utils/exists.sh` if needed
4. **no child-to-parent edges** - child cannot source parent (directory hierarchy prevents it)

**this structure makes cycles structurally impossible:**
- child lives under parent in directory tree
- child cannot source parent without violating directory conventions
- siblings cannot source each other (would create ambiguous ordering)
- all dependencies flow down the tree or across at same level

### cycles are signals for extraction

if you want to create a cycle, **don't**. the urge to create a cycle is the architecture telling you something:

**scenario 1: child needs parent's function**

this is fine - parent already loaded it before sourcing child.

```bash
# bash/utils/tui.sh
utils_tui_error() { ... }
source "${module_dir}/tui/template.sh"

# bash/utils/tui/template.sh
utils_tui_template_file() {
  # just use utils_tui_error - parent loaded it
  utils_tui_error --message="..."
}
```

**scenario 2: parent needs child's function**

this means the function is in the wrong place. move it to parent or extract to sibling.

```bash
# bad: parent needs child's function
# bash/utils/tui.sh needs utils_tui_template_parse() from bash/utils/tui/template.sh
# solution: move utils_tui_template_parse to bash/utils/tui.sh (parent)
```

**scenario 3: two modules need each other**

this means they're actually one module, or both need a third module.

```bash
# bad: module A needs function from module B, and B needs function from A
# solution 1: merge A and B (they're coupled, make it explicit)
# solution 2: extract shared functionality to module C, both depend on C

bash/
├── module_c.sh         # shared functionality
├── module_a.sh         # sources module_c.sh
└── module_b.sh         # sources module_c.sh
```

**scenario 4: cross-cutting concern**

if an abstraction crosses the parent/child boundary in ways that create cycles, **extract it from ish entirely.**

```bash
# bad: complex interdependencies that want to be circular
# solution: extract to separate library, ish sources it

external-lib/           # separate project
└── shared.sh

bash/
├── module_a.sh         # sources external-lib/shared.sh
└── module_b.sh         # sources external-lib/shared.sh
```

**key insight: cycles indicate coupling.** if you can't avoid a cycle, the coupled code should be isolated (merged or extracted). the dag structure forces you to make coupling explicit.

### enforcing the dag

**conventions define structure:**
- parent/child relationships follow directory hierarchy
- source statements only flow downward or across
- documented in this file

**structure enforces dag:**
- directory tree prevents child-to-parent dependencies
- explicit sourcing makes all edges visible
- growth pattern (functions → module → subdirectory) maintains dag

**tooling validates compliance:**
- custom shellcheck rules detect cycles
- lint checks verify source statements match conventions
- tests verify behavior at each node

**the dag is the architecture.** everything else (routing, naming, growth pattern) exists to support the dag structure.

## sourcing dependencies

every file explicitly sources what it needs at the top of the file:

```bash
#!/usr/bin/env bash

script_dir=$(cd "$(dirname "${bash_source[0]}")/../.." &>/dev/null && pwd -p)

source "${script_dir}/bash/utils/tui.sh"
source "${script_dir}/bash/platform.sh"
source "${script_dir}/bash/bootstrap/posix.sh"
```

**rules:**
- all `source` statements must be at the top of the file, immediately after shebang and directory setup
- never source files conditionally or inside functions
- list dependencies in a logical order (utilities first, then domain modules)

**benefits:**
- self-documenting dependencies at a glance
- files can be tested in isolation
- no hidden coupling
- double-sourcing is safe (just redefines functions)

## environment variables

**all environment variables set by ish must be prefixed with `ish_`**

this prevents namespace collisions with user/system environment variables.

**examples:**
```bash
# tui color variables
ISH_TUI_ERROR='\033[0;31m'
ISH_TUI_CLEAR='\033[0m'
ISH_TUI_INFO='\033[0;32m'
ISH_TUI_WARN='\033[0;33m'

ISH_TEST_FIXTURES="/tmp/ish_fixtures"
```

**naming pattern:**
- `ish_` prefix (required)
- module/subsystem identifier (`tui_`, `test_`, etc.)
- specific variable name (`error`, `fixtures`, etc.)

**rationale:**
- clear ownership - all ISH_* variables belong to ish
- avoids stomping user variables (utils_tui_error could conflict with function names)
- easy to grep for all ish environment state
- follows common practice (BATS_*, DOCKER_*, etc.)

### ISH_TESTING flag

**test mode flag enables fixture-based testing.**

`ISH_TESTING=true` signals modules to use test fixtures instead of production data:

```bash
# in module code
module_function() {
  local data_dir

  if [[ "${ISH_TESTING:-false}" == "true" ]]; then
    data_dir="${script_dir}/test/fixtures/module"
  else
    data_dir="${script_dir}/module"
  fi

  # use data_dir for operations
}
```

**guidelines:**
- check `ISH_TESTING` at function entry, set data paths accordingly
- default to `false` with `${ISH_TESTING:-false}` pattern
- only use for path/data switching, not logic changes
- never set ISH_TESTING in production code (tests only)

## module-level variables

### script_dir and module_dir

**every module file that sources submodules must define namespaced module_dir.**

modules use two path variables for sourcing dependencies:
- `script_dir`: root of the repository (always the same)
- `*_module_dir`: directory containing the current module (namespaced)

**the problem:**

when modules source each other, variable collisions break path resolution:

```bash
# bash/bootstrap/posix.sh
module_dir=/path/to/bash/bootstrap  # set correctly
source "${script_dir}/bash/utils/tui.sh"  # sources tui.sh
# tui.sh redefines module_dir=/path/to/bash (collision!)
source "${module_dir}/posix/nix.sh" # now broken - wrong path
```

**the solution: namespace module_dir by file path**

```bash
# bash/utils/tui.sh
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." &>/dev/null && pwd -P)
tui_module_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source "${script_dir}/bash/utils/exists.sh"
source "${tui_module_dir}/tui/template.sh"

# bash/bootstrap/posix.sh
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." &>/dev/null && pwd -P)
bootstrap_posix_module_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source "${script_dir}/bash/utils/tui.sh"
source "${script_dir}/bash/utils.sh"
source "${bootstrap_posix_module_dir}/posix/nix.sh"
```

**naming pattern:**
- `bash/utils/tui.sh` → `tui_module_dir`
- `bash/utils.sh` → `utils_module_dir`
- `bash/bootstrap/posix.sh` → `bootstrap_posix_module_dir`
- `bash/bootstrap/macos.sh` → `bootstrap_macos_module_dir`
- pattern: convert file path to snake_case, append `_module_dir`

**rules:**
- never use unnamespaced `module_dir` (causes collisions)
- namespace based on full module path from bash/ directory
- use `script_dir` for sourcing peer modules (no namespace needed - always same value)
- use `*_module_dir` for sourcing submodules within same hierarchy
- declare both at top of file, before any source statements

**rationale:**
- prevents variable collisions when modules compose
- maintains module boundaries (respects DAG architecture)
- makes dependencies explicit and traceable
- enables safe cross-module sourcing

## local variables

**all local variables must be declared at the top of the function.**

```bash
function_name() {
  local required_arg="${1:-}"
  local optional_arg="${2:-default}"
  local computed_var
  local result

  # function body
  computed_var=$(some_command)
  result=$(another_command)

  return_to_caller "$result"
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
utils_tui_error --message="text"  # exits immediately with code 1
utils_tui_warn --message="text"   # continues execution
utils_tui_info --message="text"   # continues execution
```

**`utils_tui_error` semantics:**
- prints error message to stderr
- exits immediately with code 1
- no need for `return 1` or `exit 1` after calling it
- use for unrecoverable errors (missing dependencies, invalid state)

**`utils_tui_warn` semantics:**
- prints warning message to stderr
- continues execution
- use for recoverable issues (already installed, skipping optional step)

**pattern in routing functions:**
```bash
case "${1-}" in
  command)
    do_something
    ;;
  *)
    some_help                                      # show help first
    utils_tui_error --message="unknown command"   # then fail fast
    ;;
esac
```

**other conventions:**
- use `set -eeuo pipefail` in entry points
- use `${1-}` instead of `$1` to handle empty args
- check platform with `platform_os()` public api: `if [[ $(platform_os) == "macos" ]]; then`

## output patterns: explicit intent

**separate concerns: messages vs data output**

the tui module provides distinct functions for different output purposes:

**message functions** (stderr):
- `utils_tui_error --message="text"` - error messages, exits with code 1
- `utils_tui_warn --message="text"` - warning messages, continues
- `utils_tui_info --message="text"` - info messages, continues
- `utils_tui_template()` - string templating with {{variable}} substitution

**file output functions** (stdout):
- `utils_tui_template_file --path=file` - outputs file contents to stdout

**why separate?**

1. **composability** - stdout can be piped, redirected, or captured
   ```bash
   # capture file contents in variable
   content=$(ish tui template file --path=board.md)

   # pipe to other commands
   ish tui template file --path=data.json | jq '.items'

   # redirect to file
   ish tui template file --path=template.conf > /etc/app.conf
   ```

2. **clarity** - explicit function names document intent
   ```bash
   utils_tui_info --message="loading template"          # user message
   utils_tui_template_file --path=kanban/board.md       # data output
   ```

3. **unix philosophy** - errors to stderr, data to stdout
   - messages don't pollute data streams
   - scripts can capture output without filtering error messages
   - standard unix conventions

**file output module structure:**

```
bash/
├── tui.sh              # router + message functions
└── tui/
    └── template.sh     # file output functions
```

**plain output functions** (stdout):
- `utils_output "value"` - outputs to stdout (safe for return values, help text, data)

**explicit intent pattern:**

```bash
# return value (captured with command substitution)
platform_os() {
  # ... logic ...
  utils_output "macos"
}
os=$(platform_os)  # captures "macos"

# help text (plain stdout, pipeable)
utils_help() {
  utils_output "usage: ish utils [command]"
  utils_output ""
  utils_output "commands:"
  utils_output "  exists    check if things exist"
}

# user messages (stderr, colored)
utils_tui_info --message="detected platform: $os"
utils_tui_warn --message="unsupported platform"
utils_tui_error --message="platform detection failed"

# file/data output (stdout, pipeable)
utils_tui_template_file --path=board.md
```

**why utils_output?**

1. **safe** - handles edge cases (dash-prefixed args, newlines, special characters)
   ```bash
   # broken: echo treats -n as a flag
   echo "-n"  # outputs nothing

   # safe: printf doesn't interpret arguments
   utils_output "-n"  # outputs "-n"
   ```

2. **explicit** - replaces bare echo/printf with clear intent
   ```bash
   # ambiguous
   echo "value"  # return value? message? help text?

   # clear
   utils_output "value"  # plain stdout output
   ```

3. **consistent** - complements utils_tui_* message functions
   - `utils_stream_stdout` → stdout (return values, data)
   - `utils_tui_info/warn/error` → stderr (user messages, colored)
   - avoid bare `echo` and `printf` (ambiguous intent)

**when to use:**
- use `utils_stream_stdout` for return values, plain data output
- use `utils_stream_multiline_stderr` for help text
- use `utils_tui_*` for user-facing operational messages
- avoid bare `echo` and `printf` in favor of explicit functions

**child modules don't source parent:**

`bash/utils/tui/template.sh` depends on `utils_tui_error` and `utils_exists_file`, but doesn't source them:

```bash
#!/usr/bin/env bash

# tui template module - file output functions
# dependencies: utils_tui_error, utils_exists_file
# these functions are available because bash/utils/tui.sh sources dependencies before this module

utils_tui_template_file() {
  local path=""

  # ... uses utils_tui_error and utils_exists_file
}
```

parent `bash/utils/tui.sh` sources dependencies first, then sources child:

```bash
#!/usr/bin/env bash

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." &>/dev/null && pwd -P)
module_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source "${script_dir}/bash/utils/exists.sh"  # provides utils_exists_file
source "${module_dir}/tui/template.sh"        # can now use dependencies
```

**why this pattern?**

- **enforces dag structure** - see [dag architecture](#dag-architecture-the-foundation)
- **no circular dependencies** - child can't source parent that sources child
- **explicit dependency chain** - parent controls what's available
- **clear ownership** - parent manages dependencies, child implements functionality
- **testable** - unit tests source dependencies explicitly in setup()

this pattern is how the dag architecture manifests in code. the directory tree defines nodes, source statements define edges, and the parent/child relationship ensures acyclicity.

**unit test pattern for child modules:**

```bash
setup() {
  load '../../test_helper/common-setup'
  _common_setup

  # source dependencies in correct order
  source bash/utils/tui.sh              # provides utils_tui_error
  source bash/utils/exists.sh           # provides utils_exists_file
  source bash/utils/tui/template.sh     # the module being tested
}
```

**integration test pattern:**

integration tests use the cli directly, so dependencies are handled automatically:

```bash
@test "ish tui template file outputs file contents" {
  run ./ish tui template file --path=test/fixtures/tui/test-file.txt
  assert_success
  assert_output --partial "line one"
}
```

## utility abstractions

extract common patterns into `bash/utils.sh` when they repeat **2+ times**.

**the 2+ rule:**
- 1 occurrence → write inline
- 2+ occurrences → extract to utility function
- abstractions emerge from actual repetition, not speculation

**example patterns:**
```bash
# pattern: checking if command exists (4 occurrences in codebase)
if type brew > /dev/null 2>&1; then

# extracted to:
if utils_is_installed brew; then

# pattern: checking if file exists (2 occurrences in codebase)
if [[ -f "$nix_conf" ]]; then

# extracted to:
if utils_file_exists "$nix_conf"; then
```

**naming convention:**
- use `utils_is_*` for boolean checks that return true/false
- use `utils_*_exists` for existence checks
- follow bash conventions: return 0 for true, non-zero for false

## stream separation: stdout vs stderr

**the insight: in bash, terminal UI IS stream management.**

both terminal ui and stream separation are about routing text to file descriptors. they're not separate concerns - terminal ui is implemented as stream management.

### the unix philosophy

**stdout (fd 1)**: data - the actual output/return value of a function
**stderr (fd 2)**: diagnostics - messages, warnings, errors, status updates

from wikipedia on [standard streams](https://en.wikipedia.org/wiki/Standard_streams):

> standard error is another output stream typically used by programs to output error messages or diagnostics. it is a stream independent of standard output and can be redirected separately.
>
> this solves the semi-predicate problem, allowing output and errors to be distinguished, and is analogous to a function returning a pair of values – see semipredicate problem § multivalued return.

**our interpretation:** we treat all informational messages as diagnostics (stderr), not just errors. this keeps data streams clean when piping or capturing output.

### the architecture

**foundation layer: `bash/utils/stream.sh`**
```bash
utils_stream_stdout()  # printf '%s\n' "$*" >&1
utils_stream_stderr()  # printf '%s\n' "$*" >&2
```

- safe output via printf (handles `-n` flags, special chars, newlines)
- no dependencies - this is the base layer
- used by everything else

**terminal ui layer: `bash/utils/tui.sh`**
```bash
utils_tui_error()  # colored error message, exits with code 1
utils_tui_warn()   # colored warning message, continues execution
utils_tui_info()   # colored info message, continues execution
```

- decorated output with colors and formatting
- all output to stderr (diagnostics)
- depends on stream layer

### usage patterns

**internal functions return data via stdout:**
```bash
platform_os() {
  utils_stream_stdout "macos"  # fd 1
}

# calling code captures clean data
os=$(platform_os)  # os="macos", no pollution
```

**cli routing outputs messages via stderr:**
```bash
utils_route() {
  case "${1-}" in
    *)
      utils_tui_error --message="unknown command: ${1-}"  # fd 2, exits
      ;;
  esac
}
```

**template rendering outputs to stdout:**
```bash
utils_tui_template_file --path=template.conf > output.conf
```

**benefits:**
- data is clean when piped or captured: `os=$(platform_os)`
- errors never pollute stdout: `2>&1` required to see them in captures
- composable: `platform_os | grep linux` works correctly
- testable: can test stdout and stderr separately

### when to use each

**use `utils_stream_stdout` when:**
- function returns data meant to be captured
- outputting template/file contents
- returning computed values

**use `utils_tui_error` when:**
- invalid input or missing required parameters
- operation failed and cannot continue
- use `--message=` flag for error text
- automatically exits with code 1

**use `utils_tui_warn` when:**
- operation succeeded but with caveats
- deprecated features used
- non-fatal issues detected

**use `utils_tui_info` when:**
- reporting progress or status
- confirming successful operations
- verbose output for debugging
- help text and usage messages

**use bare `echo` only when:**
- single-line internal piping: `echo "$var" | command`
- interactive prompts with flags: `echo -n "prompt" >&2`
- never for multi-line output or user-facing messages

### the dag: no circular dependencies

**before the refactor:**
```
bash/tui.sh ──sources──> bash/utils.sh
bash/utils.sh ──sources──> bash/tui.sh   # CIRCULAR!
```

**after the refactor:**
```
bash/utils.sh ──sources──> bash/utils/stream.sh
                       ──sources──> bash/utils/tui.sh

bash/utils/tui.sh ──sources──> bash/utils/stream.sh
                          ──sources──> bash/utils/exists.sh
```

no cycles - tui is now a child of utils, uses stream directly.

## comments

- keep code comments minimal
- document **why**, not **what**
- complex patterns reference docs: `# see docs/explicit_routing.md`
- put extensive documentation in `docs/` directory

## documentation style

**writing style: ee cummings meets hemingway**
- lowercase throughout documentation (headings, body text, lists)
- only capitalize proper nouns (macos, github, ansible, etc.)
- brief, direct sentences
- conversational tone
- humor and satire welcome ("bash sed into submission", "we live in the best of all possible worlds")
- avoid marketing language and hype

**rationale:**
- consistency with how people naturally communicate
- reduces cognitive load (no shifting between cases)
- focuses attention on content, not formatting
- proper nouns stand out clearly when everything else is lowercase
- brevity and clarity over formality
- humor makes technical content more enjoyable

**examples:**
```markdown
## command structure                    ✓ correct

commands follow left-to-right scope narrowing:

## command structure                    ✗ wrong

commands follow left-to-right scope narrowing:
```

**exceptions:**
- code blocks maintain their natural casing (bash functions, file paths, etc.)
- proper nouns always capitalized (macos, linux, javascript, etc.)
- acronyms remain uppercase (cli, api, ssh, etc.)

## testing conventions

### tests first: specs as documentation

**write failing tests before implementation.**

tests are not just verification - they are executable specifications that document behavior at both unit and integration levels.

**why tests first:**

1. **tests are specifications**
   - unit tests document function behavior: inputs, outputs, edge cases
   - integration tests document cli behavior: commands, flags, error messages
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
   - safety net for future changes

**the pattern:**

```bash
# 1. write failing test (documents desired behavior)
@test "ish kanban show outputs board.md" {
  run ./ish kanban show
  assert_success
  assert_output --partial "## milestones"
}

# 2. run test (verify it fails)
$ ./ish self test all
# ✗ ish kanban show outputs board.md

# 3. implement minimal code to pass
kanban_show() {
  cat "${script_dir}/kanban/board.md"
}

# 4. run test (verify it passes)
$ ./ish self test all
# ✓ ish kanban show outputs board.md
```

**levels of testing:**

- **unit tests** (`test/unit/`) - test individual functions in isolation
  - document function contracts (inputs → outputs)
  - test edge cases and error conditions
  - use fixtures to control dependencies

- **integration tests** (`test/integration/`) - test cli commands end-to-end
  - document user-facing behavior
  - test command composition and routing
  - verify help text, error messages, exit codes

**when writing tests:**
- start with integration test (document cli behavior)
- add unit tests for complex logic or edge cases
- test error paths, not just happy paths
- use fixtures to make tests deterministic

**tests answer questions:**
- "what does this command do?" → read integration test
- "what are the edge cases?" → read unit tests
- "how do I use this function?" → read test examples
- "what changed in this pr?" → see which tests were added/modified

### fixture pattern for deterministic tests

use fixtures to simulate external state instead of relying on environment-specific conditions.

**problem:** bootstrap tests depend on external state (e.g., "is nix installed?")

**solution:** create fake executables/files that simulate the required state

```bash
setup() {
  load '../test_helper/common-setup'
  _common_setup
  load '../test_helper/fixtures'
}

teardown() {
  fixture_cleanup
}

@test "ish bootstrap posix nix is idempotent" {
  fixture_executable nix  # creates fake nix in path

  run ./ish bootstrap posix nix
  assert_success
  assert_output --partial "already installed"
}
```

**fixture helpers:**
- `fixture_executable <name>` - creates `/tmp/ish_fixtures/<name>_test_bin` with executable bit, prepends to path
- `fixture_file <name>` - creates `/tmp/ish_fixtures/<name>_test_file`
- `fixture_cleanup` - removes `/tmp/ish_fixtures` and cleans path

**benefits:**
- tests run deterministically across all environments
- no dependency on actual installed software
- tests actual code paths (not mocking internals)
- concurrent test execution safe (unique names per fixture)

**convention:** name fixtures descriptively after what they simulate (`nix`, `brew`, `cargo`)

### no skipped tests

**we don't skip tests.** a skipped test is a bug.

if a test can't run:
1. use fixtures to create the required state
2. remove the test if fundamentally untestable
3. fix the underlying issue

skipped tests accumulate as technical debt that never gets paid.
