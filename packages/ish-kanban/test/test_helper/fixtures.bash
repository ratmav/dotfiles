#!/usr/bin/env bash

# Create dynamic kanban task fixture
# Usage: fixture_kanban_task_create
# Creates: test/fixtures/kanban/tasks/test-task.md
# Used by: kanban integration tests for create/read/delete operations
fixture_kanban_task_create() {
  local script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." &>/dev/null && pwd -P)
  local task_file="$script_dir/test/fixtures/kanban/tasks/test-task.md"

  mkdir -p "$(dirname "$task_file")"
  cat > "$task_file" <<'EOF'
# test-task

**milestone:** 1 - test milestone

**dependencies:** none

## description

dynamic test fixture for kanban task operations

## subtasks

- [ ] test subtask one
- [ ] test subtask two

## deliverable

verify task management commands work correctly
EOF
}

# Destroy dynamic kanban task fixture
# Usage: fixture_kanban_task_destroy
# Removes: test/fixtures/kanban/tasks/test-task.md
fixture_kanban_task_destroy() {
  local script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." &>/dev/null && pwd -P)
  local task_file="$script_dir/test/fixtures/kanban/tasks/test-task.md"

  rm -f "$task_file"
}
