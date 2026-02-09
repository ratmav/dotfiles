## Current Repo Restructure

### Goal

Organize current dotfiles repo to match future package structure WITHOUT splitting repos yet.

### Current Structure

```
dotfiles/
├── bash/
├── neovim/
├── docs/
├── test/
└── ish
```

### Target Structure

```
dotfiles/
├── packages/
│   ├── core/                          # Will become github/ratmav/ish
│   │   ├── source/
│   │   │   ├── utils/
│   │   │   ├── platform.sh
│   │   │   ├── registry.sh           # NEW
│   │   │   └── package.sh            # NEW
│   │   ├── test/
│   │   │   └── (core tests)
│   │   ├── docs/
│   │   │   └── (core docs)
│   │   └── data/                      # Empty
│   │
│   └── bootstrap/                     # Will become github/ratmav/dotfiles
│       ├── source/
│       │   ├── bootstrap/
│       │   ├── git/
│       │   ├── kanban/
│       │   ├── nix/
│       │   └── self/
│       ├── test/
│       │   └── (bootstrap tests)
│       ├── docs/
│       │   └── (bootstrap docs)
│       └── data/                      # The actual dotfiles!
│           ├── .bashrc
│           ├── .bash_profile
│           ├── wezterm.lua
│           └── neovim/
│
├── ish                                # Entry point (sources from packages/)
├── kanban/                            # Project management (meta)
├── CLAUDE.md                          # Project instructions (meta)
└── README.md                          # Project readme (meta)
```

---

