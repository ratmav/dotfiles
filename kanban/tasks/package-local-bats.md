# package-local bats and dotfiles test scaffold

**milestone:** 1 - restructure

**parent task:** execute migration_path.md Step 1 (12-step restructure)

**dependencies:** complete-namespace-restructure.md (completed)

## description

Make each package self-contained with its own bats copy and placeholder tests. Fixes issues discovered after namespace restructure:

1. Shared `test/bats` at repo root blocks package independence
2. `./ish test/` directory pollutes autocomplete
3. Empty `packages/dotfiles/test/` directories are footguns
4. No scaffold examples for dotfiles package tests

**Current state:**
```
test/
├── bats/           # Shared bats-core clone (blocks package independence)
└── (was unit/ and integration/, now moved to packages/ish/test/)

packages/ish/test/
├── unit/           # Has tests, uses ${ISH_PACKAGES_DIR}/../test/bats
├── integration/    # Has tests, uses ${ISH_PACKAGES_DIR}/../test/bats
├── fixtures/       # Test fixtures
└── test_helper/    # Bats helpers

packages/dotfiles/test/
├── unit/           # EMPTY (footgun)
└── integration/    # EMPTY (footgun)
```

**Target state:**
```
packages/ish/test/
├── bats/           # Package-local bats copy
├── unit/           # Uses ./bats/bin/bats
├── integration/    # Uses ./bats/bin/bats
├── fixtures/
└── test_helper/

packages/dotfiles/test/
├── bats/           # Package-local bats copy
├── unit/
│   └── hello.bats  # Placeholder test (scaffold example)
├── integration/
│   └── hello.bats  # Placeholder test (scaffold example)
└── test_helper/    # Shared bats helpers

test/               # REMOVED (no longer needed)
```

**Why:** When packages split into separate repos, each needs its own bats copy. Version pinning via BATS_VERSION files enables reproducibility.

## subtasks

### 1. Version pinning
- [ ] Create `packages/ish/test/BATS_VERSION` (v1.13.0-10-g5f12b31, commit 5f12b317)
- [ ] Create `packages/dotfiles/test/BATS_VERSION` (same version)

### 2. Copy bats to packages
- [ ] Copy `test/bats/` → `packages/ish/test/bats/`
- [ ] Copy `test/bats/` → `packages/dotfiles/test/bats/`

### 3. Update bats paths
- [ ] Update `packages/ish/source/test.sh` to use `${ISH_PACKAGES_DIR}/ish/test/bats/bin/bats`
- [ ] Update `packages/dotfiles/source/test.sh` to use `${ISH_PACKAGES_DIR}/dotfiles/test/bats/bin/bats`

### 4. Add dotfiles test infrastructure
- [ ] Copy `packages/ish/test/test_helper/` → `packages/dotfiles/test/test_helper/`
- [ ] Create `packages/dotfiles/test/unit/hello.bats` (scaffold example)
- [ ] Create `packages/dotfiles/test/integration/hello.bats` (scaffold example)

### 5. Cleanup and verify
- [ ] Remove `test/` directory (after copying bats)
- [ ] Verify `./ish test unit` runs ish tests (39 tests)
- [ ] Verify `./ish dotfiles test unit` runs dotfiles hello-world test (1 test)
- [ ] Verify tab completion doesn't show `./ish test/` directory

## deliverable

Each package has its own bats copy at pinned version. Dotfiles has scaffold tests. No shared dependencies at repo root. Clean autocomplete.

## critical files

- `packages/ish/test/BATS_VERSION` - CREATE
- `packages/dotfiles/test/BATS_VERSION` - CREATE
- `packages/ish/test/bats/` - COPY from test/bats
- `packages/dotfiles/test/bats/` - COPY from test/bats
- `packages/dotfiles/test/test_helper/` - COPY from ish
- `packages/dotfiles/test/unit/hello.bats` - CREATE
- `packages/dotfiles/test/integration/hello.bats` - CREATE
- `packages/ish/source/test.sh` - UPDATE paths
- `packages/dotfiles/source/test.sh` - UPDATE paths
- `test/` - DELETE

## implementation notes

**BATS_VERSION file content:**
```
version: v1.13.0-10-g5f12b31
commit: 5f12b3172105a0f26bce629ff8ae0ac76c4bd61e
source: https://github.com/bats-core/bats-core.git
copied: 2026-02-09
```

**Dotfiles unit test scaffold (packages/dotfiles/test/unit/hello.bats):**
```bash
#!/usr/bin/env bats

setup() {
  load '../test_helper/common-setup'
  _common_setup
}

@test "dotfiles package unit test scaffold" {
  # This is a placeholder test demonstrating the structure
  # Real dotfiles tests will validate bootstrap, git, nix functionality
  run echo "hello from dotfiles unit tests"
  assert_success
  assert_output "hello from dotfiles unit tests"
}
```

**Dotfiles integration test scaffold (packages/dotfiles/test/integration/hello.bats):**
```bash
#!/usr/bin/env bats

setup() {
  load '../test_helper/common-setup'
  _common_setup
}

@test "dotfiles package integration test scaffold" {
  # This is a placeholder test demonstrating the structure
  # Real integration tests will validate end-to-end dotfiles workflows
  run ./ish dotfiles help
  assert_success
  assert_output --partial "usage: ish dotfiles"
}
```

**Path updates in test.sh files:**
- ish: `${ISH_PACKAGES_DIR}/../test/bats/bin/bats` → `${ISH_PACKAGES_DIR}/ish/test/bats/bin/bats`
- dotfiles: All bats references should use `${ISH_PACKAGES_DIR}/dotfiles/test/bats/bin/bats`

## benefits

1. **Package independence**: Can split repos without breaking tests
2. **Version pinning**: BATS_VERSION files enable reproducible test environment
3. **Clean autocomplete**: No `./ish test/` directory pollution
4. **Scaffold examples**: Hello-world tests guide future dotfiles test development
5. **No footguns**: Test directories populated, won't be lost

## future work

When adding real dotfiles tests:
- Replace hello.bats placeholders with actual tests
- Test bootstrap functionality (posix, kali, macos)
- Test git utilities (clean, prune)
- Test nix generation
- Follow the scaffold pattern established by hello.bats
