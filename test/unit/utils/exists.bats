#!/usr/bin/env bats

setup() {
  load '../../test_helper/common-setup'
  _common_setup

  load '../../test_helper/fixtures'

  source bash/utils/tui.sh
  source bash/utils/exists.sh
}

teardown() {
  fixture_cleanup
}

# Baseline check: deliberately tests consistent system state (bash always exists)
@test "utils_exists_executable detects bash" {
  assert utils_exists_executable --executable=bash
}

@test "utils_exists_executable detects fixture executable" {
  fixture_executable mycommand_test_bin
  assert utils_exists_executable --executable=mycommand_test_bin
}

@test "utils_exists_executable rejects nonexistent commands" {
  refute utils_exists_executable --executable=fake_command_xyz_does_not_exist
}

@test "utils_exists_executable requires --executable=" {
  run utils_exists_executable
  assert_failure
  assert_output --partial "--executable= required"
}

@test "utils_exists_executable rejects unknown options" {
  run utils_exists_executable --unknown="value"
  assert_failure
  assert_output --partial "unknown option"
}

@test "utils_exists_file detects fixture file" {
  fixture_file myfile_test_file
  assert utils_exists_file --file="$ISH_TEST_FIXTURES/myfile_test_file"
}

@test "utils_exists_file rejects nonexistent files" {
  refute utils_exists_file --file=/tmp/fake_file_xyz_does_not_exist
}

@test "utils_exists_file rejects directories" {
  refute utils_exists_file --file="$ISH_TEST_FIXTURES"
}

@test "utils_exists_file requires --file=" {
  run utils_exists_file
  assert_failure
  assert_output --partial "--file= required"
}

@test "utils_exists_file rejects unknown options" {
  run utils_exists_file --unknown="value"
  assert_failure
  assert_output --partial "unknown option"
}
