#!/usr/bin/env bats

# integration tests for ish kanban commands
# documents cli behavior for kanban board

setup() {
  load '../test_helper/common-setup'
  _common_setup

  export ISH_TESTING=true
}

teardown() {
  unset ISH_TESTING
}

# kanban help - shows generic top-level help

@test "ish kanban help shows usage" {
  run ./ish kanban help
  assert_success
  assert_output --partial "usage: ish kanban"
}

@test "ish kanban help shows generic commands" {
  run ./ish kanban help
  assert_success
  assert_output --partial "show"
  assert_output --partial "task"
  assert_output --partial "scratch"
}

@test "ish kanban with no args shows help" {
  run ./ish kanban
  assert_success
  assert_output --partial "usage: ish kanban"
}

# kanban show - outputs board.md as markdown

@test "ish kanban show outputs board content" {
  run ./ish kanban show
  assert_success
  assert_output --partial "## milestones"
  assert_output --partial "milestone 1: test milestone"
}

@test "ish kanban show includes task links" {
  run ./ish kanban show
  assert_success
  assert_output --partial "[test-task](tasks/test-task.md)"
}
