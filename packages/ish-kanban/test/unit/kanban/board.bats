#!/usr/bin/env bats

bats_require_minimum_version 1.5.0

setup() {
  load '../../test_helper/common-setup'
  _common_setup

  export ISH_TESTING=true

  source "${ISH_CORE}/source/packages.sh"
  source "${ISH_CORE}/source/utils.sh"
  source "${ISH_PACKAGES}/ish-kanban/source/kanban/board.sh"
}

teardown() {
  unset ISH_TESTING
}

# ish_kanban_board_parse - extracts task locations as TSV

@test "ish_kanban_board_parse succeeds on fixture board" {
  run ish_kanban_board_parse
  assert_success
}

@test "ish_kanban_board_parse outputs three tab-separated fields" {
  run ish_kanban_board_parse
  assert_success
  run bash -c "echo '${lines[0]}' | awk -F'\t' '{print NF}'"
  assert_output "3"
}

@test "ish_kanban_board_parse extracts todo task" {
  run ish_kanban_board_parse
  assert_success
  assert_line "test-task	todo	1"
}

@test "ish_kanban_board_parse extracts completed task" {
  run ish_kanban_board_parse
  assert_success
  assert_line "completed-task	completed	1"
}

@test "ish_kanban_board_parse outputs nothing for empty board" {
  local empty_board
  empty_board="$(ish_packages_data_dir "ish-kanban")/empty_board.md"
  echo "" > "$empty_board"

  local orig_board
  orig_board="$(ish_packages_data_dir "ish-kanban")/board.md"
  mv "$orig_board" "$orig_board.bak"
  mv "$empty_board" "$orig_board"

  run ish_kanban_board_parse
  assert_success
  assert_output ""

  mv "$orig_board.bak" "$orig_board"
}

# ish_kanban_board_get_milestone_desc - extracts milestone description

@test "ish_kanban_board_get_milestone_desc returns description for valid milestone" {
  run ish_kanban_board_get_milestone_desc 1
  assert_success
  assert_output "test milestone"
}

@test "ish_kanban_board_get_milestone_desc returns empty for nonexistent milestone" {
  run ish_kanban_board_get_milestone_desc 999
  assert_success
  assert_output ""
}

@test "ish_kanban_board_get_milestone_desc fails when no argument provided" {
  run ish_kanban_board_get_milestone_desc
  assert_failure
  assert_output --partial "milestone number required"
}

# ish_kanban_board_validate_milestone - checks milestone exists

@test "ish_kanban_board_validate_milestone succeeds for valid milestone" {
  run ish_kanban_board_validate_milestone 1
  assert_success
}

@test "ish_kanban_board_validate_milestone fails for invalid milestone" {
  run ish_kanban_board_validate_milestone 999
  assert_failure
}

@test "ish_kanban_board_validate_milestone fails when no argument provided" {
  run ish_kanban_board_validate_milestone
  assert_failure
  assert_output --partial "milestone number required"
}
