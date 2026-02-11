# Package Loading Strategy

## Problem

When ish loads, it needs to scan for packages. But if the framework itself lives inside `packages/`, the scanner tries to load ish as a package of itself → **bootstrapping paradox**.

## Solution: Framework vs Packages Separation

**Principle:** The framework that loads packages cannot itself be a package.

**Structure:**
- **Framework** (`core/`) - Core system, never scanned as a package
- **Packages** (`packages/` or `~/.ish/packages/`) - Discovered and loaded by framework

## Directory Layout

### Development Mode

```
~/Source/dotfiles/
├── ish -> core/bin/ish                 # Convenience symlink
├── core/                               # Framework (mirrors ~/.ish/core/)
│   ├── bin/ish                         # Entry point
│   ├── source/                         # Core modules
│   │   ├── core.sh                     # Future: ish_core_* functions
│   │   ├── tui.sh                      # Terminal UI
│   │   ├── platform.sh                 # Platform detection
│   │   ├── registry.sh                 # Future: package registry
│   │   └── package.sh                  # Future: package management
│   ├── test/                           # Framework tests
│   └── docs/                           # Framework docs
└── packages/                           # Packages (mirrors ~/.ish/packages/)
    ├── ish-dotfiles/                   # A package (peer, not child)
    │   ├── source/
    │   ├── bin/                        # Package binaries (optional)
    │   └── test/bats/                  # Own submodules, no nesting
    └── [future packages]/
```

### Installed Mode (Future)

```
~/.ish/
├── core/                               # Framework (immutable, git managed)
│   ├── bin/ish                         # Entry point
│   ├── source/                         # Framework modules
│   ├── test/                           # Framework tests
│   └── docs/                           # Framework docs
└── packages/                           # Packages (mutable, git managed)
    ├── ish-dotfiles/                   # Flat namespace (no nesting)
    │   ├── source/
    │   └── bin/                        # Package binaries
    └── ish-foo/
```

## Loading Sequence

### 1. Entry Point Execution

`core/bin/ish` executes:

```bash
#!/usr/bin/env bash
set -euo pipefail

# Calculate paths (dev: ~/Source/dotfiles, installed: ~/.ish)
ISH_ROOT=$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/../.." && pwd -P)
ISH_CORE="${ISH_ROOT}/core/source"
ISH_PACKAGES="${ISH_ROOT}/packages"

export ISH_ROOT ISH_CORE ISH_PACKAGES
```

### 2. Load Framework Core

Framework modules load first, providing foundation for all packages:

```bash
# Load core utilities
source "${ISH_CORE}/tui.sh"          # ish_utils_tui_* functions
source "${ISH_CORE}/platform.sh"     # ish_platform_* functions
ish_utils_tui_set_colors             # Initialize color support

# Future: Load more core modules
# source "${ISH_CORE}/core.sh"       # ish_core_* functions
# source "${ISH_CORE}/registry.sh"   # ish_registry_* functions
# source "${ISH_CORE}/package.sh"    # ish_package_* functions
```

### 3. Discover Packages (Phase 1: Explicit)

Currently packages are explicitly routed:

```bash
case "${1-}" in
  dotfiles)
    source "${ISH_PACKAGES}/ish-dotfiles/source/dotfiles.sh"
    ish_dotfiles_route "$@"
    ;;
  kanban)
    source "${ISH_CORE}/kanban.sh"  # Note: ish package, part of framework
    ish_kanban_route "$@"
    ;;
  # ... etc
esac
```

### 4. Discover Packages (Phase 3+: Auto-Discovery)

Future implementation will scan packages directory:

```bash
# Scan for installed packages
for pkg_dir in "${ISH_PACKAGES}"/*; do
  [[ -d "${pkg_dir}" ]] || continue

  # Load package metadata
  pkg_name=$(basename "${pkg_dir}")
  pkg_manifest="${pkg_dir}/package.json"

  # Verify package structure
  [[ -f "${pkg_manifest}" ]] || continue

  # Source package router
  pkg_router="${pkg_dir}/source/${pkg_name}.sh"
  [[ -f "${pkg_router}" ]] && source "${pkg_router}"
done
```

### 5. Dispatch to Command

After all modules are loaded, dispatch to the requested command:

```bash
# Package commands
if type -t "ish_${cmd}_route" &>/dev/null; then
  "ish_${cmd}_route" "$@"
  exit $?
fi

# Framework commands
if type -t "ish_${cmd}_main" &>/dev/null; then
  "ish_${cmd}_main" "$@"
  exit $?
fi

# No match
ish_utils_tui_error --message="Unknown command: ${cmd}"
exit 1
```

## Principles

### 1. Framework Loads First

Core utilities (`ish_utils_tui_*`, `ish_platform_*`) must be available before any package loads.

**Why:** Packages use framework functions for:
- TUI operations (colors, prompts, messages)
- Platform detection (OS, distro, architecture)
- Error handling (fail-fast with proper messages)

### 2. Framework is Special

Framework lives in `core/`, **never** in `packages/`.

**Why:** Prevents bootstrapping recursion. The thing doing the loading cannot be one of the things being loaded.

### 3. Packages are Peers

All packages in `packages/`, flat structure, no nesting.

**Why:**
- No nested git submodules (painful to manage)
- Clear namespace (`packages/github-user-repo/`)
- Simple discovery (scan one directory level)

### 4. Auto-Discovery (Future)

Scan `packages/` to find installed packages, no hardcoded list.

**Why:**
- Dynamic package installation (Phase 3+)
- No manual registration
- Mirrors plugin systems (vim, zsh, etc.)

## Path Resolution

### Environment Variables

Set by entry point, available to all code:

```bash
ISH_ROOT       # Repository root (or ~/.ish in installed mode)
ISH_CORE       # Framework source directory (core/source/)
ISH_PACKAGES   # Packages directory
```

### Framework Module References

From any code:
```bash
source "${ISH_CORE}/tui.sh"      # Load framework TUI module
ish_utils_tui_info "message"     # Call framework function
```

### Package References

From framework code:
```bash
source "${ISH_PACKAGES}/ish-dotfiles/source/dotfiles.sh"
ish_dotfiles_route "$@"
```

From package code (referencing framework):
```bash
source "${ISH_CORE}/platform.sh"
os=$(ish_platform_os_detect)
```

## Benefits

### No Bootstrapping Paradox

Framework is **never** scanned as a package. The loader and the loaded are separate.

### No Nested Submodules

- `ish` framework: standalone repo → `core/`
- `ish-dotfiles` package: standalone repo → `packages/ish-dotfiles/`
- Both are peers, not parent/child

`ish-dotfiles` can have its own submodules (`test/bats/`) without nesting inside framework's submodules.

### Simple Single-Directory Installation

Everything ish-related in one place:
- `~/.ish/core/` - Framework (read-only, git managed)
- `~/.ish/packages/` - Packages (mutable, git managed)
- Easy to backup, sync, or remove entire `~/.ish/` directory
- Development structure mirrors installed structure exactly

### Works in Both Modes

**Development:**
```bash
cd ~/Source/dotfiles
./ish kanban show           # Uses relative paths from ./core/
```

**Installed:**
```bash
ish kanban show             # Uses absolute paths from ~/.ish/core/
```

Same code, different base paths via `${ISH_ROOT}`, `${ISH_CORE}`, `${ISH_PACKAGES}`.

### Future-Proof

When ish splits to separate repo (Phase 6):
- Framework → `github.com/ratmav/ish` (installed to `~/.ish/core/`)
- Packages → Various repos (installed to `~/.ish/packages/`)
- **No structural changes needed** - paths already correct

## PATH Management

### Installation

`ish install` command:
1. Clones ish framework to ~/.ish/core/
2. Adds ~/.ish/core/bin to PATH in shell rc files
3. Uses ish_filesystem_line_in_file for idempotent insertion
4. Checks ~/.bashrc and ~/.zshrc for existing entry

### Package Binaries

Packages can provide binaries in their bin/ directory:
- `packages/ish-dotfiles/bin/`
- These can be added to PATH: `~/.ish/packages/ish-dotfiles/bin`
- Managed by package install command

### Implementation

```bash
ish_filesystem_line_in_file() {
  local file="$1"
  local line="$2"

  # Check if line already exists
  if grep -Fxq "$line" "$file" 2>/dev/null; then
    return 0  # Already present
  fi

  # Add line
  echo "$line" >> "$file"
}
```

## Migration Plan

See task `implement-package-loading-strategy.md` for step-by-step restructure:
1. `git mv packages/ish core`
2. Update path calculations in entry point (use `ISH_CORE`)
3. Update references in package code
4. Implement `ish_filesystem_line_in_file` module
5. Implement `ish install` command with PATH management
6. Update tests
7. Verify all commands work

## Future Enhancements

### Phase 3: Package Registry

- Packages declare metadata in `package.json`
- Registry tracks installed packages
- Dependency resolution

### Phase 4: Dynamic Installation

- `ish package install github-user-repo`
- Clone to `packages/` or `~/.ish/packages/`
- Auto-discover on next invocation

### Phase 5: Dependency Management

- Packages declare dependencies in metadata
- Loader resolves and loads in dependency order
- Detect and fail on circular dependencies

### Phase 6: Framework Split

- Framework becomes standalone repo
- Installed via `ish self-install` (or system package manager)
- Packages remain in `~/.ish/packages/`
- Clear separation between framework (immutable) and packages (mutable)
