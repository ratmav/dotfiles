#!/usr/bin/env bats

setup() {
  load '../../test_helper/common-setup'
  _common_setup
}

@test "ish utils exists help shows usage" {
  run ./ish utils exists help
  assert_success
  assert_output --partial "usage: ish utils exists"
}

@test "ish utils exists --executable=bash detects bash" {
  run ./ish utils exists --executable=bash
  assert_success
  assert_output --partial "executable 'bash' exists"
}

@test "ish utils exists --executable= rejects nonexistent command" {
  run ./ish utils exists --executable=fake_nonexistent_xyz
  assert_failure
  assert_output --partial "not found"
}

@test "ish utils exists --file=/etc/hosts detects file" {
  run ./ish utils exists --file=/etc/hosts
  assert_success
  assert_output --partial "file '/etc/hosts' exists"
}

@test "ish utils exists --file= rejects nonexistent file" {
  run ./ish utils exists --file=/tmp/fake_nonexistent_xyz
  assert_failure
  assert_output --partial "not found"
}

@test "ish utils exists rejects unknown options" {
  run ./ish utils exists --unknown="value"
  assert_failure
  assert_output --partial "unknown option"
}
