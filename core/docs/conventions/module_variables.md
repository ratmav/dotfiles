# module-level variables

## module_dir

**every module file that sources submodules must define namespaced module_dir.**

modules use a path variable for sourcing submodules:
- `*_module_dir`: directory containing the current module (namespaced by function prefix)

**the problem:**

when modules source each other, variable collisions break path resolution:

```bash
# source/foo.sh
module_dir=/path/to/source/foo  # set correctly
source "${ISH_CORE}/source/tui.sh"  # sources tui.sh
# tui.sh redefines module_dir=/path/to/source (collision!)
source "${module_dir}/foo/bar.sh" # now broken - wrong path
```

**the solution: derive module_dir from the function name prefix**

the variable name is the module's function prefix + `_module_dir`. the function
prefix already guarantees uniqueness (it's how we namespace everything else), so
module_dir just follows the same rule.

```bash
# core module: functions are ish_tui_*, so variable is ish_tui_module_dir
ish_tui_module_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source "${ish_tui_module_dir}/stream.sh"
source "${ish_tui_module_dir}/tui/template.sh"

# package module: functions are foo_bar_*, so variable is foo_bar_module_dir
foo_bar_module_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source "${ISH_CORE}/source/tui.sh"
source "${foo_bar_module_dir}/bar/baz.sh"
```

**naming pattern:**
- function prefix `ish_tui_*` → `ish_tui_module_dir`
- function prefix `ish_stream_*` → `ish_stream_module_dir`
- function prefix `foo_bar_*` → `foo_bar_module_dir`
- function prefix `foo_bar_baz_*` → `foo_bar_baz_module_dir`
- pattern: take the module's function prefix, append `_module_dir`

**rules:**
- never use unnamespaced `module_dir` (causes collisions)
- derive name from function prefix (not file path — paths change when repos split)
- use `*_module_dir` for sourcing submodules within same hierarchy
- declare at top of file, before any source statements

**repo split migration path:**

function prefixes are stable identifiers — they don't change when repos split.
directory structure is an artifact of where code lives today; function prefixes
encode what the code *is*.

| phase | location | function prefix | module_dir |
|---|---|---|---|
| now (monorepo) | `core/source/tui.sh` | `ish_tui_*` | `ish_tui_module_dir` |
| now (monorepo) | `packages/ish-kanban/source/kanban.sh` | `ish_kanban_*` | `ish_kanban_module_dir` |
| after split | `ish/source/tui.sh` | `ish_tui_*` | `ish_tui_module_dir` |
| after split | `ish-kanban/source/kanban.sh` | `ish_kanban_*` | `ish_kanban_module_dir` |

nothing changes. that's the point.

**rationale:**
- prevents variable collisions when modules compose
- maintains module boundaries (respects DAG architecture)
- makes dependencies explicit and traceable
- enables safe cross-module sourcing
- survives repo restructuring (function prefix is the stable identity)
