# test organization

## directory structure

```
test/
├── bats/                    # bats-core test runner (git submodule)
├── test_helper/
│   ├── bats-support/        # test utilities (git submodule)
│   ├── bats-assert/         # assertion functions (git submodule)
│   ├── common-setup.bash    # centralized library loader
│   └── fixtures.bash        # fixture helpers
├── unit/                    # module isolation tests (mirrors source/ structure)
│   ├── color.bats
│   ├── file_descriptor.bats
│   ├── platform.bats
│   ├── stream.bats
│   ├── tui.bats
│   ├── tui/
│   │   └── template.bats
│   ├── utils.bats
│   └── utils/
│       └── exists.bats
└── integration/             # cli functional tests
    ├── core.bats
    ├── core/
    │   ├── lint.bats
    │   └── test.bats
    ├── platform.bats
    ├── utils.bats
    └── utils/
        ├── exists.bats
        ├── tui.bats
        └── tui/
            └── template.bats
```

## mirroring pattern

**test structure mirrors source structure:**
- **unit tests** mirror source: `source/platform.sh` → `test/unit/platform.bats`
- **integration tests** mirror cli commands: `./ish platform os` → `test/integration/platform.bats`
- parallel structures make gaps visible and enable scaffolding tools
- missing test file = untestable (modifies system state) or not yet implemented

## unit tests

exercise individual modules in isolation by sourcing files directly.

- fast execution
- test single functions
- direct function calls (no cli)
- isolated from external dependencies

## integration tests

exercise cross-module interactions and the cli as users invoke it.

- test real user workflows
- exercise full routing stack
- verify help text and error handling
- any test that spans multiple modules, not just cli

## coverage philosophy

- core logic modules (platform, utils, tui) have unit tests
- infrastructure wrappers (git, self) have integration tests only
- don't unit test wrappers around external tools (git commands, shellcheck, network apis)
- integration tests verify routing and composition, not duplicate unit coverage
