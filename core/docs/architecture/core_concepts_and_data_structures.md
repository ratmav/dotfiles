## Core Concepts & Data Structures

### Registry System

**Location:** `~/.ish/core/data/registry.txt`

**Format:** Git URLs, one per line
```
<git-url>
```

**Example:**
```
# ish user registry
# Add packages with: ish registry add <url>
https://github.com/ratmav/ish-dotfiles.git
git@github.com:ratmav/ish-docker.git
https://github.com/user/ish-homelab.git
```

**Package Name Extraction:**
Package name is extracted from git URL (last component before `.git`):
- `https://github.com/ratmav/ish-dotfiles.git` → `ish-dotfiles`
- `git@github.com:user/ish-docker.git` → `ish-docker`
- `https://gitlab.com/foo/ish-ratfiles.git` → `ish-ratfiles`

**Properties:**
- Simple line-based format (grep-able, awk-able)
- One git URL per line
- User-managed via `ish registry add/remove/list` commands
- Package names extracted from URLs must be globally unique
- Validation prevents namespace collisions
- Uses `ish_filesystem_line_in_file` for idempotent operations

**Commands:**
- `ish package list` - Show all registered URLs and extracted package names
- `ish package add <url>` - Clone, validate (GPG + tests + lint), add to registry
- `ish package remove <url>` - Remove from filesystem and registry
- `ish package update <name>` - Pull and validate

**Validation Requirements:**
- All commits must be GPG signed
- Package tests must pass
- Linting must pass
- If validation fails during `add`: clone is removed
- If validation fails during `update`: warning (not auto-removed)

**Package Naming:**
Repository name (in git URL) must:
- Start with `ish-` prefix (e.g., `ish-dotfiles`, `ish-ratfiles`)
- Be globally unique in user's registry
- Be valid as directory names
- Examples: `ish-dotfiles`, `ish-ratfiles`, `ish-docker`, `ish-homelab`

### Package Installation Location

**Location:** `~/.ish/packages/`

**Convention:** Flat structure with extracted package name

**Example:**
```
~/.ish/packages/
├── ish-dotfiles/
├── ish-ratfiles/
├── ish-docker/
└── ish-homelab/
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
