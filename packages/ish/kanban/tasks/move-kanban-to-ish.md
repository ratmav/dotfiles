# move kanban data to ish package

**milestone:** 1 - restructure

**parent task:** execute migration_path.md Step 1 (12-step restructure)

**dependencies:** complete-namespace-restructure.md (completed)

## description

Move kanban board and task data into the ish package structure. Kanban functionality is part of the ish package, so board.md and tasks/ should live at `packages/ish/kanban/` not at repo root.

**Issue discovered:** kanban task/scratch commands are currently broken due to undefined `script_dir` variable. This is a pre-existing bug that we'll fix as part of the move.

**Current state:**
```
kanban/
├── board.md
├── scratch.md
└── tasks/
    └── *.md

packages/ish/source/kanban/
├── task.sh        # BROKEN: uses ${script_dir}/kanban (script_dir undefined)
└── scratch.sh     # BROKEN: uses ${script_dir}/kanban (script_dir undefined)

packages/ish/source/kanban.sh
└── kanban_show()  # Uses ${ISH_PACKAGES_DIR}/../kanban
```

**Test results:**
```bash
$ ./ish kanban show
# Works (uses ISH_PACKAGES_DIR/../kanban)

$ ./ish kanban task list
line 63: script_dir: unbound variable
# BROKEN
```

**Target state:**
```
packages/ish/kanban/
├── board.md
├── scratch.md
└── tasks/
    └── *.md

packages/ish/source/kanban/
└── All functions use ${ISH_PACKAGES_DIR}/ish/kanban
```

## subtasks

### 1. Move kanban data
- [ ] Move `kanban/` → `packages/ish/kanban/`
- [ ] Verify directory structure intact (board.md, scratch.md, tasks/)

### 2. Fix path references in kanban.sh
- [ ] Update `kanban_show()` line 15:
  - From: `kanban_dir="${ISH_PACKAGES_DIR}/../kanban"`
  - To: `kanban_dir="${ISH_PACKAGES_DIR}/ish/kanban"`

### 3. Fix path references in task.sh (and fix script_dir bug)
- [ ] Line 43 (kanban_task_delete):
  - From: `kanban_dir="${script_dir}/kanban"`
  - To: `kanban_dir="${ISH_PACKAGES_DIR}/ish/kanban"`
- [ ] Line 63 (kanban_task_list):
  - From: `kanban_dir="${script_dir}/kanban"`
  - To: `kanban_dir="${ISH_PACKAGES_DIR}/ish/kanban"`
- [ ] Line 100 (kanban_task_new):
  - From: `kanban_dir="${script_dir}/kanban"`
  - To: `kanban_dir="${ISH_PACKAGES_DIR}/ish/kanban"`
- [ ] Line 144 (kanban_task_path):
  - From: `kanban_dir="${script_dir}/kanban"`
  - To: `kanban_dir="${ISH_PACKAGES_DIR}/ish/kanban"`
- [ ] Line 178 (kanban_task_show):
  - From: `kanban_dir="${script_dir}/kanban"`
  - To: `kanban_dir="${ISH_PACKAGES_DIR}/ish/kanban"`

### 4. Fix path references in scratch.sh (and fix script_dir bug)
- [ ] Line 25 (kanban_scratch_path):
  - From: `kanban_dir="${script_dir}/kanban"`
  - To: `kanban_dir="${ISH_PACKAGES_DIR}/ish/kanban"`
- [ ] Line 56 (kanban_scratch_capture):
  - From: `kanban_dir="${script_dir}/kanban"`
  - To: `kanban_dir="${ISH_PACKAGES_DIR}/ish/kanban"`
- [ ] Line 71 (kanban_scratch_show):
  - From: `kanban_dir="${script_dir}/kanban"`
  - To: `kanban_dir="${ISH_PACKAGES_DIR}/ish/kanban"`

### 5. Verify functionality
- [ ] `./ish kanban show` displays board
- [ ] `./ish kanban task list` lists all tasks
- [ ] `./ish kanban task show --name=package-local-bats` displays task
- [ ] `./ish kanban scratch show` displays scratch file
- [ ] Test fixtures still work (ISH_TESTING=true paths unchanged)

## deliverable

Kanban data lives at `packages/ish/kanban/`. All kanban functions use consistent path references. Pre-existing script_dir bug fixed.

## critical files

- `kanban/` → `packages/ish/kanban/` - MOVE
- `packages/ish/source/kanban.sh` - UPDATE (1 path reference)
- `packages/ish/source/kanban/task.sh` - UPDATE (5 path references, fixes script_dir bug)
- `packages/ish/source/kanban/scratch.sh` - UPDATE (3 path references, fixes script_dir bug)

## implementation notes

**Consistent path pattern:**
```bash
if [[ "${ISH_TESTING:-false}" == "true" ]]; then
  kanban_dir="${ISH_PACKAGES_DIR}/ish/test/fixtures/kanban"
else
  kanban_dir="${ISH_PACKAGES_DIR}/ish/kanban"
fi
```

**Why this fixes script_dir bug:**
- `script_dir` was never defined anywhere in the codebase
- Replacing with `${ISH_PACKAGES_DIR}/ish/kanban` uses an existing, properly-defined variable
- Makes kanban path determination consistent across all functions

**Test fixture paths remain unchanged:**
All functions already correctly use `${ISH_PACKAGES_DIR}/ish/test/fixtures/kanban` when testing.

## benefits

1. **Package alignment**: Kanban data lives with kanban source code
2. **Bug fix**: Resolves undefined script_dir causing task/scratch commands to fail
3. **Consistency**: All kanban functions use same path pattern
4. **Testability**: Test fixture paths remain isolated and working
