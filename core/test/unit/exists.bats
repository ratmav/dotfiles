#!/usr/bin/env bats

setup() {
  load '../test_helper/common-setup'
  _common_setup

  load '../test_helper/fixtures'

  source ${ISH_CORE}/source/exists.sh
}

teardown() {
  fixture_cleanup
}

# Baseline check: deliberately tests consistent system state (bash always exists)
@test "ish_exists_executable detects bash" {
  assert ish_exists_executable --executable=bash
}

@test "ish_exists_executable detects fixture executable" {
  fixture_executable mycommand_test_bin
  assert ish_exists_executable --executable=mycommand_test_bin
}

@test "ish_exists_executable rejects nonexistent commands" {
  refute ish_exists_executable --executable=fake_command_xyz_does_not_exist
}

@test "ish_exists_executable requires --executable=" {
  run ish_exists_executable
  assert_failure
  assert_output --partial "--executable= required"
}

@test "ish_exists_executable rejects unknown options" {
  run ish_exists_executable --unknown="value"
  assert_failure
  assert_output --partial "unknown option"
}
