# implement package registry system

**milestone:** 3 - core implementation (fp-style)

**dependencies:** build-fp-core-stream, build-fp-core-validate (includes namespace validation), build-fp-core-semantic

## description

Build package registry system in ish/registry module. Registry data lives in registry/data/packages/*.conf. Registry commands use ish_core_* primitives.

Publishing = PR to ish repo to add package.conf. CI runs validation to enforce namespace uniqueness.

## subtasks

**Registry Module Structure:**
- [ ] create source/registry/ module
- [ ] create source/registry/data/packages/ directory
- [ ] define package metadata format (bash-parseable *.conf)
- [ ] add initial packages (ish.conf, ish_dotfiles.conf)

**Registry Commands (source/registry/):**
- [ ] implement `ish_registry_search` - find packages by query
- [ ] implement `ish_registry_list` - show all packages
- [ ] implement `ish_registry_show` - display package details
- [ ] implement `ish_registry_validate` - check namespace uniqueness
- [ ] implement `ish_registry_parse_package` - parse *.conf files

**Package Installation:**
- [ ] implement `ish_package_install_from_registry`
- [ ] lookup package in registry/data/packages/
- [ ] read metadata, get repo URL
- [ ] clone and install package
- [ ] validate namespace matches metadata

**Namespace Validation (uses ish_core_namespace_*):**
- [ ] `ish_registry_validate` calls `ish_core_namespace_check_uniqueness`
- [ ] check data/packages/ for duplicate namespaces
- [ ] fail if duplicates found, show conflicting packages
- [ ] can run as cron job / CI check

**Router Integration:**
- [ ] add `ish registry` command routing
- [ ] add `ish package install <namespace>` with registry lookup

**Testing:**
- [ ] unit tests for metadata parsing (bash-format)
- [ ] unit tests for namespace validation
- [ ] integration tests for search/list
- [ ] integration tests for install from registry

**CI Integration:**
- [ ] add `ish registry validate` to CI workflow
- [ ] run on PR that modifies registry/data/packages/
- [ ] fail PR if namespace collision

**Documentation:**
- [ ] publishing workflow (PR to add *.conf)
- [ ] package metadata schema
- [ ] registry commands usage

## deliverable

Working registry system with validation, search, and install capabilities.

## notes

**Structure:**
```
core/source/registry/
├── search.sh
├── install.sh
├── list.sh
├── validate.sh
├── parse.sh
└── data/
    └── packages/
        ├── ish.conf
        └── ish_dotfiles.conf
```

Note: After restructure, framework is in `core/` (see task `implement-package-loading-strategy.md`).

**Package metadata format (bash-parseable):**
```bash
# core/source/registry/data/packages/ish.conf
namespace="ish"
repo="https://github.com/ratmav/ish.git"
author="ratmav"
version="0.1.0"
description="Functional bash task runner and dotfiles manager"
```

**Parse with source:**
```bash
ish_registry_parse_package() {
  local conf_file="$1"
  source "$conf_file"  # Loads namespace, repo, author, etc.
  echo "$namespace $repo $author $version"
}
```

**Registry commands use ish_core_*:**
```bash
ish_registry_search() {
  local query=$(ish_core_parse_option "--query" "$@")
  ish_core_require_nonempty "$query"

  find "$registry_data" -name "*.conf" | \
    ish_core_stream_filter "grep -q '$query'" | \
    ish_core_stream_map "ish_registry_parse_package"
}
```

**Validation command (uses ish_core_namespace_*):**
```bash
ish registry validate

# Implementation:
ish_registry_validate() {
  local registry_data="${ISH_CORE}/registry/data/packages"

  # Use core namespace validation
  local namespaces=()
  for conf in "$registry_data"/*.conf; do
    namespaces+=($(ish_core_namespace_parse "$conf"))
  done

  ish_core_namespace_check_uniqueness "${namespaces[@]}" || \
    ish_core_fail_with "namespace collision detected in registry"
}

# Exit 0 = valid, Exit 1 = collision
```

**Publishing workflow:**
1. Fork ish repo
2. Add core/source/registry/data/packages/my_package.conf
3. Submit PR
4. CI runs `ish registry validate`
5. If validation passes → merge → published
6. If collision → fail with error

**Install workflow:**
```bash
ish package install my_package

# 1. Read ${ISH_CORE}/registry/data/packages/my_package.conf
# 2. Get repo URL
# 3. Clone repo
# 4. Install to ${ISH_PACKAGES}/ (packages/ in dev, ~/.ish/packages/ when installed)
# 5. Validate namespace matches
```

**Why bash-parseable format:**
- Simple: just source the file
- Type-safe: bash variables, not string parsing
- Extensible: add new fields easily
- Familiar: same format as other configs

**Namespace uniqueness enforced at:**
1. **Publish time:** CI runs validate on PR
2. **Install time:** Check registry + local packages
3. **Runtime:** In-memory check on package load

**Version pinning (future-proofing):**

Registry format designed to support version specs (not implemented initially):
```bash
# Current (always HEAD):
ish package install github/ratmav/ish-docker

# Future (when needed):
ish package install github/ratmav/ish-docker@v1.2.3
ish package install github/ratmav/ish-docker@commit-sha
ish package install github/ratmav/ish-docker@HEAD  # explicit
```

Default behavior: pull HEAD (always be upgrading philosophy)
Version pinning: opt-in when stability needed

Design considerations:
- [ ] Registry format supports version field (but defaults to HEAD)
- [ ] Parse `@version` suffix if provided
- [ ] Validate: git tag exists / commit SHA exists
- [ ] Document: version pinning is opt-in
