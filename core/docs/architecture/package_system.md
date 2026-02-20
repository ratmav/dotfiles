# package system

## the bootstrapping paradox

when ish loads, it scans for packages. if the framework itself lived in `packages/`, the scanner would try to load ish as a package of itself.

**solution:** the framework that loads packages cannot itself be a package. framework lives in `core/`, never in `packages/`.

## directory layout

**development mode:**
```
~/Source/dotfiles/
├── ish -> core/bin/ish           # convenience symlink
├── core/                         # framework (mirrors ~/.ish/core/)
│   ├── bin/ish                   # entry point
│   ├── source/                   # core modules
│   ├── test/                     # framework tests
│   └── docs/                     # framework docs
└── packages/                     # packages (mirrors ~/.ish/packages/)
    ├── ish-kanban/               # peer package
    └── ish-ratfiles/             # peer package
```

**installed mode (future):**
```
~/.ish/
├── core/                         # framework (immutable, git managed)
│   ├── bin/ish
│   ├── source/
│   ├── test/
│   └── docs/
└── packages/                     # packages (mutable, git managed)
    ├── ish-kanban/
    └── ish-ratfiles/
```

same code, different base paths via `${ISH_ROOT}`. user clones to `~/.ish/`, then `ish install` adds `~/.ish/core/bin` to `$PATH` in the shell config.

## principles

1. **framework loads first** — core utilities must be available before any package loads
2. **framework is special** — lives in `core/`, never scanned as a package
3. **packages are peers** — flat structure in `packages/`, no nesting
4. **package independence** — each package is self-contained (own tests, own docs, own bats submodules). can move to separate repo without breaking.

## standard package structure

```
packages/<name>/
├── source/
│   ├── <name>.sh              # package router
│   └── [modules]/             # feature modules
├── test/
│   ├── bats/                  # submodule: bats-core
│   ├── test_helper/
│   │   ├── bats-support/      # submodule
│   │   ├── bats-assert/       # submodule
│   │   ├── common-setup.bash
│   │   └── fixtures.bash
│   ├── unit/
│   └── integration/
├── docs/
└── data/                      # optional
```

## trust model

no `curl | bash`. ish uses clone, inspect, verify:

1. `git clone` — code on disk before execution
2. inspect — plain text, auditable
3. `ish validate` — check git integrity, gpg signatures, keyserver, structure, tests
4. `ish install` — add `~/.ish/core/bin` to `$PATH` in shell config

trust anchors: git sha integrity + gpg signature identity + out-of-band key verification. see `design_decisions.md` for full trust model comparison.
