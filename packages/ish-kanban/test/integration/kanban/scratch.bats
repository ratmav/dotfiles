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
  assert_output --partial "capture"
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
  assert_output --partial "${ISH_PACKAGES}/ish-kanban/test/fixtures/scratch.md"
}

# kanban scratch capture - appends quick note to scratch

@test "ish kanban scratch capture appends message to scratch" {
  # get initial content
  local scratch_path
  scratch_path=$(./ish kanban scratch path)

  local initial_content
  initial_content=$(cat "${scratch_path}")

  # capture message
  run ./ish kanban scratch capture --message="test idea"
  assert_success
  assert_output --partial "captured: test idea"

  # verify message was appended
  local final_content
  final_content=$(cat "${scratch_path}")

  assert [ "${final_content}" != "${initial_content}" ]
  assert grep -q "^- test idea$" "${scratch_path}"

  # cleanup: restore original content
  echo "${initial_content}" > "${scratch_path}"
}

@test "ish kanban scratch capture errors without --message" {
  run ./ish kanban scratch capture
  assert_failure
  assert_output --partial "--message is required"
}

@test "ish kanban scratch capture errors on unknown option" {
  run ./ish kanban scratch capture --invalid=option
  assert_failure
  assert_output --partial "unknown option"
}

@test "ish kanban scratch capture uses fixture in test mode" {
  # verify ISH_TESTING is set
  assert [ "${ISH_TESTING}" = "true" ]

  # verify path points to fixture
  run ./ish kanban scratch path
  assert_success
  assert_output --partial "${ISH_PACKAGES}/ish-kanban/test/fixtures/scratch.md"
}
