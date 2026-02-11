# Package Types and Structure

## Two Categories

### 1. ish (future separate repo)

**Namespace:** `github/ratmav/ish`

**Purpose:** Core utility library - "underscore.js for bash"

**Complete structure:**
```
packages/ish/
├── bin/
│   └── ish                    # Main CLI entry point
├── source/
│   ├── test.sh                # Test commands (ish test unit/integration)
│   ├── lint.sh                # Lint commands (ish lint all)
│   ├── utils/                 # Stream, exists, tui utilities
│   ├── platform.sh            # OS/arch detection
│   ├── registry.sh            # Registry management (future)
│   ├── package.sh             # Package management (future)
│   └── kanban/                # Project task management
│       ├── task.sh
│       └── scratch.sh
├── kanban/
│   ├── board.md               # Project kanban board
│   ├── scratch.md             # Quick notes
│   └── tasks/                 # Task markdown files
│       ├── *.md
├── test/
│   ├── BATS_VERSION           # Pinned bats version documentation
│   ├── bats/                  # Submodule: bats-core
│   ├── test_helper/
│   │   ├── bats-support/      # Submodule: assertion library
│   │   ├── bats-assert/       # Submodule: test helpers
│   │   ├── common-setup.bash  # Shared test setup
│   │   └── fixtures.bash      # Fixture utilities
│   ├── fixtures/              # Test data
│   │   ├── kanban/
│   │   └── tui/
│   ├── unit/                  # Fast, isolated tests
│   │   ├── platform.bats
│   │   └── utils/
│   └── integration/           # End-to-end tests
│       ├── kanban/
│       └── utils/
└── docs/                      # Package-specific documentation
```

### 2. dotfiles (stays in dotfiles repo)

**Namespace:** `github/ratmav/dotfiles`

**Purpose:** Personal dotfiles and bootstrap automation

**Complete structure:**
```
packages/ish-ratfiles/
├── source/
│   ├── ratfiles.sh            # Package router/help
│   ├── test.sh                # Test commands (ish ratfiles test unit/integration)
│   ├── lint.sh                # Lint commands (ish ratfiles lint all)
│   ├── bootstrap/             # Platform bootstrapping
│   │   ├── posix.sh
│   │   ├── kali.sh
│   │   └── macos.sh
│   ├── git/                   # Git utilities
│   │   └── clean.sh
│   └── nix/                   # Nix utilities
│       └── generate.sh
├── test/
│   ├── BATS_VERSION           # Pinned bats version documentation
│   ├── bats/                  # Submodule: bats-core
│   ├── test_helper/
│   │   ├── bats-support/      # Submodule: assertion library
│   │   ├── bats-assert/       # Submodule: test helpers
│   │   ├── common-setup.bash  # Shared test setup
│   │   └── fixtures.bash      # Fixture utilities
│   ├── unit/
│   │   └── hello.bats         # Scaffold example (replace with real tests)
│   └── integration/
│       └── hello.bats         # Scaffold example (replace with real tests)
├── docs/                      # Package-specific documentation
└── data/                      # Dotfile configurations
    ├── .bashrc
    ├── .bash_profile
    ├── wezterm.lua
    └── neovim/                # All neovim config
```

## Standard Package Scaffold

Every ish package follows this structure:

### Minimum viable package
```
packages/[name]/
├── source/
│   ├── [name].sh              # Package router (if multi-module)
│   ├── test.sh                # Test orchestration
│   └── [modules]/             # Feature modules
└── test/
    ├── BATS_VERSION           # Version pin
    ├── bats/                  # Submodule: bats-core
    ├── test_helper/
    │   ├── bats-support/      # Submodule
    │   ├── bats-assert/       # Submodule
    │   ├── common-setup.bash  # Shared setup
    │   └── fixtures.bash      # Fixture helpers
    ├── unit/
    │   └── hello.bats         # Scaffold
    └── integration/
        └── hello.bats         # Scaffold
```

### Test infrastructure explained

**BATS_VERSION:**
Documents the exact bats version for reproducibility:
```
version: v1.13.0-10-g5f12b31
commit: 5f12b3172105a0f26bce629ff8ae0ac76c4bd61e
source: https://github.com/bats-core/bats-core.git
```

**Submodules:**
- `bats/` - Test framework (bats-core)
- `test_helper/bats-support/` - Test utilities
- `test_helper/bats-assert/` - Assertion library

Each package has its own copies (submodules) for true independence.

**Scaffold tests:**
- `hello.bats` files are placeholders demonstrating structure
- Replace with real tests as package develops
- Prevents empty test directories from being lost

### Package independence principle

Each package is fully self-contained:
- Own test framework (bats submodule)
- Own test helpers (bats-support, bats-assert submodules)
- Own test scaffolds
- Own documentation
- Can be moved to separate repo without breaking

This enables:
- Clean package splitting (Phase 6)
- Independent versioning
- Separate CI/CD pipelines
- No shared dependencies at repo root
