# naming

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
function: foo_bar_action
file:     source/foo/bar.sh
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
- start with underscore prefix: `_foo_bar_is_baz()`
- not registered in routing functions
- not listed in help text
- used only internally within the same file
- can be called by other files that source the module, but shouldn't be (underscore = "don't use this")
- placed at bottom of file after routing function, alphabetized

**file structure:**
```bash
#!/usr/bin/env bash

# public functions (alphabetized)
foo_bar_one() { ... }
foo_bar_two() { ... }
foo_bar_help() { ... }
foo_bar_route() { ... }

# private functions (alphabetized)
_foo_bar_helper_one() { ... }
_foo_bar_helper_two() { ... }
```

**usage in other files:**
```bash
source "${ISH_CORE}/source/foo.sh"

# use public api
result=$(foo_bar_action)

# don't use private functions
# _foo_bar_is_baz  # don't do this!
```

## namespace collision prevention

naming conventions prevent collisions at three levels:

1. **remote uniqueness** — git hosting enforces `service/user/repo` uniqueness
2. **local uniqueness** — filesystem prevents duplicate package directories
3. **function prefixes** — all packages use `ish_` prefix to stay under the ish namespace:
   - `ish_tui_*` for core tui module
   - `ish_kanban_*` for kanban package
   - `ish_ratfiles_*` for ratfiles package
   - `ish_foo_*` for a hypothetical package named "foo"
