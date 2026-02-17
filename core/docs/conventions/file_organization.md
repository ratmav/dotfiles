# file organization

## directory structure

```
source/
  tui.sh              # terminal ui
  platform.sh         # platform detection
  stream.sh           # FP stream primitives
  color.sh            # terminal color detection
  file_descriptor.sh  # POSIX I/O
  exists.sh           # command availability (type)
  foo/
    bar.sh            # grouped functions
    bar/
      baz.sh          # further grouping when 2+ functions share prefix
```

## the growth pattern: from router to module

start simple and grow organically:

**stage 1: functions in router file**
```bash
# source/foo.sh
foo_bar_sync() { ... }
foo_baz_cleanup() { ... }

foo_route() {
  case "${1-}" in
    bar)
      shift
      case "${1-}" in
        sync) foo_bar_sync "$@" ;;
      esac
      ;;
    baz)
      shift
      case "${1-}" in
        cleanup) foo_baz_cleanup "$@" ;;
      esac
      ;;
  esac
}
```

**stage 2: extract when grouping becomes clear**

if you add more `foo_bar_*` functions, extract to a module:
```bash
# source/foo/bar.sh
foo_bar_sync() { ... }
foo_bar_local() { ... }
foo_bar_stale() { ... }

# source/foo.sh (router sources and delegates)
source "${foo_module_dir}/foo/bar.sh"

foo_route() {
  case "${1-}" in
    bar)
      shift
      case "${1-}" in
        sync) foo_bar_sync "$@" ;;
        local) foo_bar_local "$@" ;;
        stale) foo_bar_stale "$@" ;;
      esac
      ;;
  esac
}
```

**stage 3: create sub-router when crossing directory boundary**

if `bar` gets complex enough to need subdirectories:
```bash
# source/foo/bar.sh (becomes a router)
source "${foo_bar_module_dir}/bar/remote.sh"
source "${foo_bar_module_dir}/bar/local.sh"

foo_bar_route() {
  case "${1-}" in
    sync) foo_bar_sync "$@" ;;
    remote) shift; foo_bar_remote_route "$@" ;;
    local) shift; foo_bar_local_route "$@" ;;
  esac
}

# source/foo.sh
source "${foo_module_dir}/foo/bar.sh"

foo_route() {
  case "${1-}" in
    bar) shift; foo_bar_route "$@" ;;
  esac
}
```

**key principles:**
- start with functions in the router file
- extract to modules when logical grouping emerges (2+ related functions)
- functions group by **longest common prefix** (lowest common denominator)
- create sub-routers only when crossing directory boundaries
- each directory level has one router file that sources and delegates

## when to create subdirectories

create a subdirectory when:
- **2+ functions share a common prefix** beyond the module name
  - example: `foo_bar_sync`, `foo_bar_local` → create `source/foo/bar.sh`
  - repetition is jarring; address it immediately
- **logical grouping is clear** based on functionality
- **file gets long (>150 lines)** → split by functional groups

keep in parent file when:
- **single function** for a concept
- **unclear grouping** - wait until the pattern emerges (but once you have 2, extract)
