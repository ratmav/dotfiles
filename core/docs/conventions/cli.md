# cli structure

## routing grammar

```
ish [command] [subcommand] [subcommand...] [--option=value]
```

we chain **single-word subcommands** to navigate the module hierarchy. options use `--flag=value` style.

**rules:**
- each level is a **single word** (not kebab-case, not multi-word)
- commands narrow scope **left to right**
- no args = show help
- `all` keyword = run all functions in that module
- `help` works at every level
- options are `--flag=value` (equals-separated, no spaces)
- consistent across all modules

**left-to-right scope narrowing:**

each word narrows the scope of what we're doing:

```bash
ish                         # top level: ish cli wrapper
ish foo                     # foo operations
ish foo bar                 # bar sub-operations
ish foo bar action          # specific action
```

the progression is always: **general → specific → action**

**correct:**
```bash
ish foo bar baz action         # four single-word subcommands
ish foo bar action             # three single-word subcommands
ish tui info --message="text"  # subcommands + option
```

**incorrect:**
```bash
ish foo bar baz-action         # kebab-case
ish foo bar-action             # kebab-case
ish tui info --message "text"  # space-separated option
```

**function naming vs cli:**
- **cli**: single words separated by spaces → `ish foo bar action`
- **function**: underscores for the full path → `foo_bar_action()`
- underscores in function names are fine and expected

## avoiding kebab-case: function naming matters

kebab-case in cli commands is a symptom of poor function naming. the solution is to rethink the function hierarchy.

**anti-pattern: functions that don't map to single words**
```bash
# bad function names force kebab-case in cli
foo_is_installed()     → ish foo is-installed --name=bash    # kebab-case
foo_file_exists()      → ish foo file-exists --path=bar.txt  # kebab-case
```

**solution: add routing layer**
```bash
# good function names enable clean cli
foo_exists_executable()  → ish foo exists --executable=bash    # all single words
foo_exists_file()        → ish foo exists --file=bar.txt       # all single words
```

**the pattern:**
1. **identify the problem:** function name has multi-word concept (`is_installed`)
2. **extract the concept:** what category does this belong to? (`exists`)
3. **create subdirectory:** `source/foo/exists.sh`
4. **rename functions:** `foo_exists_executable()`, `foo_exists_file()`
5. **add routing:** router at `source/foo.sh` dispatches to `exists` subcommand

**structure:**
```
source/
├── foo.sh              # router with foo_route()
└── foo/
    └── bar.sh          # implementation with foo_bar_*() functions
```

**result:**
- cli: `ish foo bar --option=value` - reads naturally, all single words
- function: `foo_bar_action()` - follows naming convention
- extensible: can add `foo_bar_other()` without refactoring

## brevity and clarity

**prefer brevity.** use the minimum levels needed for the current set of commands.

**anti-pattern: premature hierarchy**
```bash
# bad: 3 levels when you only have 1 command per group
ish foo bar sync         # only one bar command exists
ish foo baz cleanup      # only one baz command exists
```

**solution: flatten until needed**
```bash
# good: 2 levels when you only have 1 command
ish foo bar              # simple, clear (only one bar operation)
ish foo baz              # simple, clear (descriptive action)
```

**when to add hierarchy:**
- add a subcommand level when you have **2+ related commands** that need grouping
- single command? keep it flat
- repetition in names signals it's time to extract
