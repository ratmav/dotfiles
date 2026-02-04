#!/usr/bin/env bats

# integration tests for ish kanban scratch commands
# documents cli behavior for scratch pad

setup() {
  load '../../test_helper/common-setup'
  _common_setup

  export ISH_TESTING=true
}

teardown() {
  unset ISH_TESTING
}

# kanban scratch help - shows scratch-specific help

@test "ish kanban scratch help shows usage" {
  run ./ish kanban scratch help
  assert_success
  assert_output --partial "usage: ish kanban scratch"
}

@test "ish kanban scratch help shows scratch commands" {
  run ./ish kanban scratch help
  assert_success
  assert_output --partial "show"
  assert_output --partial "path"
}

@test "ish kanban scratch with no args shows help" {
  run ./ish kanban scratch
  assert_success
  assert_output --partial "usage: ish kanban scratch"
}

# kanban scratch show - outputs scratch.md content

@test "ish kanban scratch show outputs scratch content" {
  run ./ish kanban scratch show
  assert_success
  assert_output "# scratch"
}

# kanban scratch path - outputs scratch.md path

@test "ish kanban scratch path outputs file path" {
  run ./ish kanban scratch path
  assert_success
  assert_output --partial "test/fixtures/kanban/scratch.md"
}
