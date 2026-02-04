## Core Concepts & Data Structures

### Registry System

**Location:** `~/.local/share/ish/remote_registry`

**Format:** Space-separated values
```
<namespace> <git_url> <local_path> <checksum>
```

**Example:**
```
github/ratmav/ish https://github.com/ratmav/ish.git /home/user/.local/share/ish/packages/github/ratmav/ish abc123...
github/ratmav/dotfiles https://github.com/ratmav/dotfiles.git /home/user/.local/share/ish/packages/github/ratmav/dotfiles def456...
```

**Fields:**
- `namespace`: `service/user/repo` (e.g., `github/ratmav/ish`, `gitlab/foo/bar`)
- `git_url`: Clone URL for the package
- `local_path`: Absolute path to local working copy
- `checksum`: Git commit SHA of HEAD (verified on install, not runtime)

**Properties:**
- Simple line-based format (grep-able, awk-able)
- Space-separated (no tabs, no make-style ambiguity)
- Namespace provides global uniqueness via git VCS constraints
- Checksum used only during install/update for verification

### Package Installation Location

**Location:** `~/.local/share/ish/packages/`

**Convention:** `packages/<service>/<user>/<repo>/`

**Example:**
```
~/.local/share/ish/packages/
├── github/
│   └── ratmav/
│       ├── ish/
│       └── dotfiles/
└── gitlab/
    └── foo/
        └── bar/
```

### Package Structure (Standardized)

Every package must follow this structure:

```
<package-root>/
├── bin/              # Executables (OPTIONAL)
├── source/           # Actual bash modules (REQUIRED)
├── test/             # BATS tests for this package (REQUIRED)
├── docs/             # Package documentation (REQUIRED)
└── data/             # Package-specific data (dotfiles, templates, etc.) (OPTIONAL)
```

**Validation:**
- `source/` directory is REQUIRED
- `test/` directory is REQUIRED
- `docs/` directory is REQUIRED
- `bin/` directory is OPTIONAL (for packages with executable commands)
- `data/` directory is OPTIONAL (most packages won't have data)
- Package functions must follow naming convention: `namespace_module_action()`

**CLI Pattern:** All commands follow `ish <domain> <action> [--options]` for consistency and clarity.

**Domain Types:**
- **Meta domains** (ish core): `package`, `register`, `self` - manage ish itself
- **Feature domains** (from packages): `kanban`, `bootstrap`, `git`, `nix`, etc. - package functionality
- Packages extend the CLI by adding new domains automatically
