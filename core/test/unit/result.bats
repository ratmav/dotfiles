#!/usr/bin/env bats

bats_require_minimum_version 1.5.0

setup() {
  load '../test_helper/common-setup'
  _common_setup

  source "${ISH_CORE}/source/result.sh"
}

# ish_result_and_then

@test "ish_result_and_then runs all functions on success" {
  _step_a() { printf "a "; }
  _step_b() { printf "b "; }
  _step_c() { printf "c"; }
  run ish_result_and_then _step_a _step_b _step_c
  assert_success
  assert_output "a b c"
}

@test "ish_result_and_then short-circuits on failure" {
  _ok() { printf "ok "; }
  _fail() { return 1; }
  _never() { printf "never"; }
  run ish_result_and_then _ok _fail _never
  assert_failure
  assert_output "ok "
}

@test "ish_result_and_then propagates exact exit code" {
  _exit_42() { return 42; }
  run ish_result_and_then _exit_42
  assert_failure
  [[ "$status" -eq 42 ]]
}

@test "ish_result_and_then requires at least one function" {
  run ish_result_and_then
  assert_failure
  assert_output --partial "ish_result:"
}

# ish_result_or_else

@test "ish_result_or_else returns primary on success" {
  _primary() { printf "primary"; }
  _fallback() { printf "fallback"; }
  run ish_result_or_else _primary _fallback
  assert_success
  assert_output "primary"
}

@test "ish_result_or_else runs fallback on failure" {
  _fail() { return 1; }
  _fallback() { printf "recovered"; }
  run ish_result_or_else _fail _fallback
  assert_success
  assert_output "recovered"
}

@test "ish_result_or_else propagates fallback failure" {
  _fail_a() { return 1; }
  _fail_b() { return 2; }
  run ish_result_or_else _fail_a _fail_b
  assert_failure
}

@test "ish_result_or_else requires primary function" {
  run ish_result_or_else
  assert_failure
  assert_output --partial "ish_result:"
}

@test "ish_result_or_else requires fallback function" {
  _ok() { return 0; }
  run ish_result_or_else _ok
  assert_failure
  assert_output --partial "ish_result:"
}

# ish_result_map

@test "ish_result_map transforms output on success" {
  _get_name() { printf "alice"; }
  _upcase() { printf "%s" "${1^^}"; }
  run ish_result_map _get_name _upcase
  assert_success
  assert_output "ALICE"
}

@test "ish_result_map propagates failure without transforming" {
  _fail() { return 1; }
  _upcase() { printf "%s" "${1^^}"; }
  run ish_result_map _fail _upcase
  assert_failure
  refute_output
}

@test "ish_result_map propagates exact exit code on failure" {
  _exit_7() { return 7; }
  _noop() { printf "%s" "$1"; }
  run ish_result_map _exit_7 _noop
  assert_failure
  [[ "$status" -eq 7 ]]
}

@test "ish_result_map requires command function" {
  run ish_result_map
  assert_failure
  assert_output --partial "ish_result:"
}

@test "ish_result_map requires transform function" {
  _ok() { printf "x"; }
  run ish_result_map _ok
  assert_failure
  assert_output --partial "ish_result:"
}
