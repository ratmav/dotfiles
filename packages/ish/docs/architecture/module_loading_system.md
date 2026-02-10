## Module Loading System

### ish Startup Sequence

```bash
#!/usr/bin/env bash
# lib/ish/bin/ish entry point

set -Eeuo pipefail

# 1. Calculate paths
#    Determine framework and package locations
ISH_ROOT=$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/../.." && pwd -P)
ISH_LIB="${ISH_ROOT}/lib/ish/lib"
ISH_PACKAGES="${ISH_ROOT}/packages"  # or ~/.local/share/ish/packages when installed

export ISH_ROOT ISH_LIB ISH_PACKAGES

# 2. Load framework core (always available)
#    Framework modules must load first - they provide foundation for all packages
source "${ISH_LIB}/tui.sh"        # ish_utils_tui_* functions
source "${ISH_LIB}/platform.sh"   # ish_platform_* functions
ish_utils_tui_set_colors          # Initialize color support

# Future: Load additional core modules
# source "${ISH_LIB}/core.sh"     # ish_core_* functions
# source "${ISH_LIB}/registry.sh" # ish_registry_* functions
# source "${ISH_LIB}/package.sh"  # ish_package_* functions

# 3. Discover installed packages
#    Phase 1: Explicit routing (current)
#    Phase 3+: Auto-discovery (future)

# Current: Explicit package loading
case "${1-}" in
  dotfiles)
    source "${ISH_PACKAGES}/ish-dotfiles/source/dotfiles.sh"
    ish_dotfiles_route "$@"
    ;;
  kanban)
    source "${ISH_LIB}/kanban.sh"  # Note: ish package, part of framework
    ish_kanban_route "$@"
    ;;
  # ... other explicit routes
esac

# Future: Auto-discovery package scanner
# for pkg_dir in "${ISH_PACKAGES}"/*; do
#   [[ -d "${pkg_dir}" ]] || continue
#   pkg_name=$(basename "${pkg_dir}")
#   pkg_manifest="${pkg_dir}/package.json"
#   [[ -f "${pkg_manifest}" ]] || continue
#
#   # Source package router
#   pkg_router="${pkg_dir}/source/${pkg_name}.sh"
#   [[ -f "${pkg_router}" ]] && source "${pkg_router}"
# done

# 4. Dispatch to command
#    Route based on first argument
cmd="${1-}"
shift || true

# Try package commands first
if type -t "ish_${cmd}_route" &>/dev/null; then
  "ish_${cmd}_route" "$@"
  exit $?
fi

# Try framework commands
if type -t "ish_${cmd}_main" &>/dev/null; then
  "ish_${cmd}_main" "$@"
  exit $?
fi

# No match
ish_utils_tui_error --message="Unknown command: ${cmd}"
exit 1
```

### Path Environment Variables

Set by entry point, available to all code:

- `ISH_ROOT` - Repository root (or `~/.local` in installed mode)
- `ISH_LIB` - Framework library directory (`lib/ish/lib/` or `~/.local/lib/ish/lib/`)
- `ISH_PACKAGES` - Packages directory (`packages/` or `~/.local/share/ish/packages/`)

### Command Namespace Examples

```bash
./ish register add --url=...           # ish core
./ish package install --namespace=...  # ish core
./ish bootstrap macos all              # dotfiles package
./ish foo command                      # from installed package "foo"
```

### Namespace Collision Prevention

**Strategy:** Rely on git VCS uniqueness + naming conventions

1. **Remote uniqueness:** Git hosting enforces `service/user/repo` uniqueness
2. **Local uniqueness:** Filesystem prevents duplicate `packages/service/user/repo/`
3. **Function prefixes:** Packages must use their repo name as prefix
   - `ish_*` for core ish functions
   - `dotfiles_*` for dotfiles package
   - `foo_*` for package named "foo"

**Example:**
- Package `github/ratmav/ish` exports functions: `ish_register_add()`, `ish_package_install()`
- Package `github/ratmav/dotfiles` exports: `dotfiles_bootstrap_macos_all()`
- Package `github/user/foo` exports: `foo_bar_baz()`

