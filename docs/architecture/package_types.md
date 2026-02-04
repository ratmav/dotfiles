## Package Types

### Two Categories

#### 1. ish (future separate repo)

**Namespace:** `github/ratmav/ish`

```
packages/ish/
├── bin/
│   └── ish           # Main CLI entry point
├── source/
│   ├── utils/        # Stream, exists, tui
│   ├── platform.sh   # OS/arch detection
│   ├── registry.sh   # Registry management (NEW)
│   ├── package.sh    # Package management (NEW)
│   ├── kanban/       # Project task management
│   └── self/         # ish's own test/lint/install commands
├── test/
└── docs/
```

**Purpose:** Core utility library - "underscore.js for bash"

**Note:** Every package has its own `self/` module for running that package's tests and linting.

#### 2. dotfiles (stays in dotfiles repo)

**Namespace:** `github/ratmav/dotfiles`

```
packages/dotfiles/
├── source/
│   ├── bootstrap/    # Platform bootstrapping
│   ├── git/          # Git utilities
│   ├── nix/          # Nix utilities
│   └── self/         # dotfiles' own test/lint commands
├── test/
├── docs/
└── data/
    ├── .bashrc
    ├── .bash_profile
    ├── wezterm.lua
    └── neovim/       # All neovim config
```

**Purpose:** Personal dotfiles and bootstrap automation
