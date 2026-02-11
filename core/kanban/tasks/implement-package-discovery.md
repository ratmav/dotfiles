# implement package discovery

**milestone:** 1 - restructure

**dependencies:** fix-ratfiles-naming (MUST complete first)

## problem

Package loading is hardcoded in entry point via explicit case statements. This:
- Blocks extensibility (can't add packages without editing core)
- Violates separation between framework and packages
- Makes testing multi-package scenarios difficult

**Current implementation** (`core/bin/ish` lines 66-70):
```bash
case "${1-}" in
  ratfiles)
    shift
    source "${ISH_PACKAGES}/ish-ratfiles/source/dotfiles.sh"
    ish_ratfiles_route "$@"
    ;;
```

## solution

Auto-discover packages using strict naming conventions. No manifest files needed.

**Convention-based discovery:**
- Scan `${ISH_PACKAGES}/ish-*/` directories
- Extract package name from directory (e.g., `ish-ratfiles` → `ratfiles`)
- Source router at `source/{name}.sh` by convention
- Call `ish_{name}_route()` function

**Key insight:** Directory name is source of truth. Everything derives from it.

## subtasks

### Phase 1: Implement Scanner

- [ ] Create `core/source/packages.sh` with discovery functions:
  - `ish_packages_discover()` - scan and source all package routers
  - `ish_packages_route()` - dispatch command to package route function

### Phase 2: Update Entry Point

- [ ] Update `core/bin/ish`:
  - Source `packages.sh` after core utilities (after line 15)
  - Call `ish_packages_discover` to load packages
  - Remove hardcoded `ratfiles` case statement
  - Update default case to try `ish_packages_route` before error

### Phase 3: Testing Infrastructure

- [ ] Create test fixture: `core/test/fixtures/packages/ish-test/source/test.sh`
- [ ] Create integration test: `core/test/integration/packages.bats`
  - Use setup to symlink fixture
  - Use teardown to clean up
  - Test discovery, routing, error handling
- [ ] Verify all existing tests pass: `./ish test all`

### Phase 4: Documentation

- [ ] Create `core/docs/conventions.md` documenting package conventions:
  - Package naming: `ish-{name}`
  - Router location: `source/{name}.sh`
  - Function naming: `ish_{name}_route()`
  - CLI command: `ish {name}`
- [ ] Update `core/docs/architecture/package_loading.md` with discovery implementation

## deliverable

- Dynamic package loading via convention-based discovery
- No hardcoded package references in entry point
- Extensible: add packages without editing core
- Automated integration tests for discovery

## critical files

### New Files
- `core/source/packages.sh` - Discovery and routing system
- `core/test/fixtures/packages/ish-test/source/test.sh` - Reusable test fixture
- `core/test/integration/packages.bats` - Integration tests for discovery
- `core/docs/conventions.md` - Package conventions documentation

### Modified Files
- `core/bin/ish` - Add discovery, remove hardcoded routing
- `core/docs/architecture/package_loading.md` - Document discovery implementation

## implementation notes

**Discovery scanner** (`core/source/packages.sh`):
```bash
ish_packages_discover() {
  local pkg_dir pkg_name pkg_router

  for pkg_dir in "${ISH_PACKAGES}"/ish-*; do
    [[ -d "${pkg_dir}" ]] || continue

    # Extract name: ish-ratfiles → ratfiles
    pkg_name="${pkg_dir##*/ish-}"

    # Source router by convention
    pkg_router="${pkg_dir}/source/${pkg_name}.sh"
    [[ -f "${pkg_router}" ]] && source "${pkg_router}"
  done
}

ish_packages_route() {
  local cmd="${1-}"
  shift || true

  # Try to route to package
  local route_fn="ish_${cmd}_route"
  if declare -F "${route_fn}" >/dev/null 2>&1; then
    "${route_fn}" "$@"
    return $?
  fi

  return 1
}
```

**Test fixture** (`core/test/fixtures/packages/ish-test/source/test.sh`):
```bash
#!/usr/bin/env bash
# Test package fixture for verifying package discovery

ish_test_route() {
  case "${1-}" in
    help|"")
      echo "Test package loaded successfully"
      echo "This is a fixture for testing package discovery"
      ;;
    *)
      echo "Unknown test command: ${1-}"
      return 1
      ;;
  esac
}
```

**Integration test** (`core/test/integration/packages.bats`):
```bash
#!/usr/bin/env bats

setup() {
  load '../test_helper/common-setup'
  _common_setup

  # Symlink fixture into packages for testing
  ln -s "${ISH_ROOT}/core/test/fixtures/packages/ish-test" \
        "${ISH_PACKAGES}/ish-test"
}

teardown() {
  # Clean up fixture symlink
  rm -f "${ISH_PACKAGES}/ish-test"
}

@test "ish discovers packages by convention" {
  run ./ish test help
  assert_success
  assert_output --partial "Test package loaded successfully"
}

@test "ish routes commands to discovered packages" {
  run ./ish test help
  assert_success
  assert_output --partial "This is a fixture for testing package discovery"
}

@test "ish handles unknown package commands" {
  run ./ish nonexistent help
  assert_failure
  assert_output --partial "unknown command: nonexistent"
}
```

## verification

```bash
# Test existing functionality
./ish ratfiles help
./ish ratfiles bootstrap help

# Run test suite (includes new discovery tests)
./ish test all               # Should pass with new integration tests
```

## notes

**Why convention over configuration:**
- Zero config overhead (no manifest files)
- Directory name is single source of truth
- Easy to validate (just check file exists)
- Enables automated testing (fixtures with setup/teardown)

**Relationship to registry (Phase 3):**
- Registry = catalog of *available* packages (remote)
- Discovery = loading *installed* packages (local)
- Registry uses `.conf` files in `core/source/registry/data/packages/`
- Discovery uses conventions, no metadata files needed

**Convention enforcement:**
Package must follow naming rules or it won't be discovered. This is intentional - forces consistency across all packages.
