## Module Loading System

### ish Startup Sequence

```bash
#!/usr/bin/env bash
# ish entry point

set -Eeuo pipefail

# 1. Load core (hardcoded, always available)
#    Core is special - it must exist for ish to function
source "${ish_core_path}/source/utils/tui.sh"
source "${ish_core_path}/source/platform.sh"
source "${ish_core_path}/source/registry.sh"
source "${ish_core_path}/source/package.sh"

# 2. Discover installed packages
#    Scan ~/.local/share/ish/packages/*/source/
for package_dir in ~/.local/share/ish/packages/*/*/*/*/source; do
  # Extract namespace from path
  # Example: ~/.local/share/ish/packages/github/ratmav/dotfiles/source
  #          → github/ratmav/dotfiles

  # 3. Load package routers (convention-based)
  #    Source all *.sh files in source/
  for module in "${package_dir}"/*.sh; do
    source "${module}"
  done
done

# 4. Dispatch to command
#    Route based on first argument
case "${1-}" in
  register)
    shift
    ish_register_route "$@"
    ;;
  package)
    shift
    ish_package_route "$@"
    ;;
  *)
    # Delegate to installed packages
    # Example: ./ish bootstrap → calls dotfiles_bootstrap_route
    # Example: ./ish foo → calls foo_route
    ;;
esac
```

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

