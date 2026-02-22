#!/usr/bin/env bats

bats_require_minimum_version 1.5.0

setup() {
  load '../test_helper/common-setup'
  _common_setup

  source "${ISH_CORE}/source/stream.sh"
}

# ish_stream_map

@test "ish_stream_map transforms each line" {
  _upcase() { printf "%s\n" "${1^^}"; }
  run ish_stream_map _upcase < <(printf '%s\n' "hello" "world")
  assert_success
  assert_line --index 0 "HELLO"
  assert_line --index 1 "WORLD"
}

@test "ish_stream_map with empty input produces no output" {
  _upcase() { printf "%s\n" "${1^^}"; }
  run ish_stream_map _upcase < <(printf "")
  assert_success
  refute_output
}

@test "ish_stream_map requires function argument" {
  run ish_stream_map
  assert_failure
  assert_output --partial "ish_stream:"
}

# ish_stream_filter

@test "ish_stream_filter selects matching lines" {
  _starts_with_a() { [[ "$1" == a* ]]; }
  run ish_stream_filter _starts_with_a < <(printf '%s\n' "apple" "banana" "avocado")
  assert_success
  assert_line --index 0 "apple"
  assert_line --index 1 "avocado"
}

@test "ish_stream_filter with no matches produces no output" {
  _starts_with_z() { [[ "$1" == z* ]]; }
  run ish_stream_filter _starts_with_z < <(printf '%s\n' "apple" "banana")
  assert_success
  refute_output
}

# ish_stream_fold

@test "ish_stream_fold reduces to single value" {
  _sum() { echo $(( $1 + $2 )); }
  run ish_stream_fold _sum 0 < <(printf '%s\n' "1" "2" "3")
  assert_success
  assert_output "6"
}

@test "ish_stream_fold with empty input returns initial accumulator" {
  _sum() { echo $(( $1 + $2 )); }
  run ish_stream_fold _sum 42 < <(printf "")
  assert_success
  assert_output "42"
}

# ish_stream_bind

@test "ish_stream_bind propagates success" {
  _double() { echo $(( $1 * 2 )); }
  run ish_stream_bind _double < <(printf '%s\n' "3" "5")
  assert_success
  assert_line --index 0 "6"
  assert_line --index 1 "10"
}

@test "ish_stream_bind short-circuits on failure" {
  _fail_on_bad() {
    if [[ "$1" == "bad" ]]; then return 1; fi
    printf "%s\n" "ok:$1"
  }
  run ish_stream_bind _fail_on_bad < <(printf '%s\n' "good" "bad" "good")
  assert_failure
  assert_output "ok:good"
}

# ish_stream_stdout / ish_stream_stderr

@test "ish_stream_stdout outputs to stdout" {
  run ish_stream_stdout "hello"
  assert_success
  assert_output "hello"
}

@test "ish_stream_stderr outputs to stderr" {
  run ish_stream_stderr "hello"
  assert_success
  assert_output "hello"
}

@test "ish_stream_stdout handles dash prefixed arguments" {
  run ish_stream_stdout "-n"
  assert_output "-n"
}

@test "ish_stream_stderr handles dash prefixed arguments" {
  run ish_stream_stderr "-n"
  assert_output "-n"
}

# ish_stream_multiline_stdout / ish_stream_multiline_stderr

@test "ish_stream_multiline_stdout outputs multiple lines" {
  run ish_stream_multiline_stdout <<EOF
line one
line two
line three
EOF
  assert_success
  assert_line --index 0 "line one"
  assert_line --index 1 "line two"
  assert_line --index 2 "line three"
}

@test "ish_stream_multiline_stderr outputs multiple lines to stderr" {
  run ish_stream_multiline_stderr <<EOF
alpha
bravo
EOF
  assert_success
  assert_line --index 0 "alpha"
  assert_line --index 1 "bravo"
}

@test "ish_stream_multiline_stdout with empty heredoc produces no output" {
  run ish_stream_multiline_stdout < <(printf "")
  assert_success
  refute_output
}
