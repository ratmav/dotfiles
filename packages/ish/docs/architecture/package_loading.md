# Package Loading Strategy

## Problem

When ish loads, it needs to scan for packages. But if the framework itself lives inside `packages/`, the scanner tries to load ish as a package of itself → **bootstrapping paradox**.

## Solution: Framework vs Packages Separation

**Principle:** The framework that loads packages cannot itself be a package.

**Structure:**
- **Framework** (`lib/ish/`) - Core system, never scanned as a package
- **Packages** (`packages/` or `~/.local/share/ish/packages/`) - Discovered and loaded by framework

## Directory Layout

### Development Mode

```
~/Source/dotfiles/
├── ish -> lib/ish/bin/ish              # Convenience symlink
├── lib/
│   └── ish/                            # Framework installation
│       ├── bin/ish                     # Entry point
│       ├── lib/                        # Core modules
│       │   ├── core.sh                 # Future: ish_core_* functions
│       │   ├── tui.sh                  # Terminal UI
│       │   ├── platform.sh             # Platform detection
│       │   ├── registry.sh             # Future: package registry
│       │   └── package.sh              # Future: package management
│       ├── test/                       # Framework tests
│       └── docs/                       # Framework docs
└── packages/
    ├── ish-dotfiles/                   # A package (peer, not child)
    │   ├── source/
    │   └── test/bats/                  # Own submodules, no nesting
    └── [future packages]/
```

### Installed Mode (Future)

```
~/.local/
├── bin/
│   └── ish -> ../lib/ish/bin/ish       # Symlink to entry point
├── lib/
│   └── ish/                            # Framework (immutable, git managed)
│       ├── bin/ish
│       └── lib/
└── share/
    └── ish/
        └── packages/                    # Packages (mutable, git managed)
            ├── github-ratmav-dotfiles/  # Flat namespace (no nesting)
            └── github-user-foo/
```

## Loading Sequence

### 1. Entry Point Execution

`lib/ish/bin/ish` executes:

```bash
#!/usr/bin/env bash
set -euo pipefail

# Calculate paths
ISH_ROOT=$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/../.." && pwd -P)
ISH_LIB="${ISH_ROOT}/lib/ish/lib"
ISH_PACKAGES="${ISH_ROOT}/packages"  # or ~/.local/share/ish/packages when installed

export ISH_ROOT ISH_LIB ISH_PACKAGES
```

### 2. Load Framework Core

Framework modules load first, providing foundation for all packages:

```bash
# Load core utilities
source "${ISH_LIB}/tui.sh"          # ish_utils_tui_* functions
source "${ISH_LIB}/platform.sh"      # ish_platform_* functions
ish_utils_tui_set_colors            # Initialize color support

# Future: Load more core modules
# source "${ISH_LIB}/core.sh"        # ish_core_* functions
# source "${ISH_LIB}/registry.sh"    # ish_registry_* functions
# source "${ISH_LIB}/package.sh"     # ish_package_* functions
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
    source "${ISH_LIB}/kanban.sh"  # Note: ish package, not external
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

Framework lives in `lib/ish/`, **never** in `packages/`.

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
ISH_ROOT       # Repository root (or ~/.local in installed mode)
ISH_LIB        # Framework library directory
ISH_PACKAGES   # Packages directory
```

### Framework Module References

From any code:
```bash
source "${ISH_LIB}/tui.sh"       # Load framework TUI module
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
source "${ISH_LIB}/platform.sh"
os=$(ish_platform_os_detect)
```

## Benefits

### No Bootstrapping Paradox

Framework is **never** scanned as a package. The loader and the loaded are separate.

### No Nested Submodules

- `ish` framework: standalone repo → `lib/ish/`
- `ish-dotfiles` package: standalone repo → `packages/ish-dotfiles/`
- Both are peers, not parent/child

`ish-dotfiles` can have its own submodules (`test/bats/`) without nesting inside framework's submodules.

### XDG Compliant

Follows system conventions:
- `~/.local/lib/` - Application libraries (read-only, versioned)
- `~/.local/share/` - User data (mutable, user-managed)
- `~/.local/bin/` - User executables (already in PATH)

Tools like nvim, systemd, and desktop environments use this pattern.

### Works in Both Modes

**Development:**
```bash
cd ~/Source/dotfiles
./ish kanban show           # Uses relative paths from ./lib/ish/
```

**Installed:**
```bash
ish kanban show             # Uses absolute paths from ~/.local/lib/ish/
```

Same code, different base paths via `${ISH_ROOT}`, `${ISH_LIB}`, `${ISH_PACKAGES}`.

### Future-Proof

When ish splits to separate repo (Phase 6):
- Framework → `github.com/ratmav/ish` (installed to `~/.local/lib/ish/`)
- Packages → Various repos (installed to `~/.local/share/ish/packages/`)
- **No structural changes needed** - paths already correct

## Migration Plan

See task `implement-package-loading-strategy.md` for step-by-step restructure:
1. `git mv packages/ish lib/ish`
2. Update path calculations in entry point
3. Update references in package code
4. Update tests
5. Verify all commands work

## Future Enhancements

### Phase 3: Package Registry

- Packages declare metadata in `package.json`
- Registry tracks installed packages
- Dependency resolution

### Phase 4: Dynamic Installation

- `ish package install github-user-repo`
- Clone to `packages/` or `~/.local/share/ish/packages/`
- Auto-discover on next invocation

### Phase 5: Dependency Management

- Packages declare dependencies in metadata
- Loader resolves and loads in dependency order
- Detect and fail on circular dependencies

### Phase 6: Framework Split

- Framework becomes standalone repo
- Installed via `ish self-install` (or system package manager)
- Packages remain in `~/.local/share/ish/packages/`
- Clear separation between framework (immutable) and packages (mutable)
