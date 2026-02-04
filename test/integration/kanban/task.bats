#!/usr/bin/env bats

# integration tests for ish kanban task commands
# documents cli behavior for task management

setup() {
  load '../../test_helper/common-setup'
  _common_setup
  load '../../test_helper/fixtures'

  export ISH_TESTING=true
}

teardown() {
  fixture_kanban_task_destroy
  rm -f test/fixtures/kanban/tasks/new-task.md
  unset ISH_TESTING
}

# kanban task help - shows task-specific help

@test "ish kanban task help shows usage" {
  run ./ish kanban task help
  assert_success
  assert_output --partial "usage: ish kanban task"
}

@test "ish kanban task help shows task commands" {
  run ./ish kanban task help
  assert_success
  assert_output --partial "list"
  assert_output --partial "new"
  assert_output --partial "delete"
  assert_output --partial "show"
  assert_output --partial "path"
}

@test "ish kanban task with no args shows help" {
  run ./ish kanban task
  assert_success
  assert_output --partial "usage: ish kanban task"
}

# kanban task list - outputs task names, one per line

@test "ish kanban task list outputs task name" {
  fixture_kanban_task_create

  run ./ish kanban task list
  assert_success
  assert_line "test-task"
}

@test "ish kanban task list outputs one task per line" {
  fixture_kanban_task_create

  run ./ish kanban task list
  assert_success
  # at least one line for test-task
  [ "${#lines[@]}" -ge 1 ]
}

# kanban task show - outputs task content

@test "ish kanban task show --name=test-task outputs task content" {
  fixture_kanban_task_create

  run ./ish kanban task show --name=test-task
  assert_success
  assert_output --partial "# test-task"
  assert_output --partial "**milestone:** 1"
}

@test "ish kanban task show requires --name flag" {
  run ./ish kanban task show
  assert_failure
  assert_output --partial "--name required"
}

@test "ish kanban task show fails on nonexistent task" {
  run ./ish kanban task show --name=nonexistent
  assert_failure
  assert_output --partial "task not found"
}

# kanban task path - outputs file path for editing

@test "ish kanban task path --name=test-task outputs file path" {
  fixture_kanban_task_create

  run ./ish kanban task path --name=test-task
  assert_success
  assert_output --partial "test/fixtures/kanban/tasks/test-task.md"
}

@test "ish kanban task path requires --name flag" {
  run ./ish kanban task path
  assert_failure
  assert_output --partial "--name required"
}

@test "ish kanban task path fails on nonexistent task" {
  run ./ish kanban task path --name=nonexistent
  assert_failure
  assert_output --partial "task not found"
}

# kanban task new - creates new task

@test "ish kanban task new --name=new-task creates task file" {
  run ./ish kanban task new --name=new-task
  assert_success

  [ -f "test/fixtures/kanban/tasks/new-task.md" ]
}

@test "ish kanban task new requires --name flag" {
  run ./ish kanban task new
  assert_failure
  assert_output --partial "--name required"
}

@test "ish kanban task new fails if task already exists" {
  fixture_kanban_task_create

  run ./ish kanban task new --name=test-task
  assert_failure
  assert_output --partial "task already exists"
}

# kanban task delete - deletes task

@test "ish kanban task delete --name=test-task removes task file" {
  fixture_kanban_task_create

  run ./ish kanban task delete --name=test-task
  assert_success

  [ ! -f "test/fixtures/kanban/tasks/test-task.md" ]
}

@test "ish kanban task delete requires --name flag" {
  run ./ish kanban task delete
  assert_failure
  assert_output --partial "--name required"
}

@test "ish kanban task delete fails on nonexistent task" {
  run ./ish kanban task delete --name=nonexistent
  assert_failure
  assert_output --partial "task not found"
}
