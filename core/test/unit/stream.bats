#!/usr/bin/env bats

setup() {
  load '../test_helper/common-setup'
  _common_setup
}

@test "ish_stream_map transforms each line" {
  run bash -c '
    source ${ISH_CORE}/source/stream.sh
    _upcase() { printf "%s\n" "${1^^}"; }
    printf "%s\n" "hello" "world" | ish_stream_map _upcase
  '
  assert_success
  assert_line --index 0 "HELLO"
  assert_line --index 1 "WORLD"
}

@test "ish_stream_map with empty input produces no output" {
  run bash -c '
    source ${ISH_CORE}/source/stream.sh
    _upcase() { printf "%s\n" "${1^^}"; }
    printf "" | ish_stream_map _upcase
  '
  assert_success
  refute_output
}

@test "ish_stream_filter selects matching lines" {
  run bash -c '
    source ${ISH_CORE}/source/stream.sh
    _starts_with_a() { [[ "$1" == a* ]]; }
    printf "%s\n" "apple" "banana" "avocado" | ish_stream_filter _starts_with_a
  '
  assert_success
  assert_line --index 0 "apple"
  assert_line --index 1 "avocado"
}

@test "ish_stream_filter with no matches produces no output" {
  run bash -c '
    source ${ISH_CORE}/source/stream.sh
    _starts_with_z() { [[ "$1" == z* ]]; }
    printf "%s\n" "apple" "banana" | ish_stream_filter _starts_with_z
  '
  assert_success
  refute_output
}

@test "ish_stream_fold reduces to single value" {
  run bash -c '
    source ${ISH_CORE}/source/stream.sh
    _sum() { echo $(( $1 + $2 )); }
    printf "%s\n" "1" "2" "3" | ish_stream_fold _sum 0
  '
  assert_success
  assert_output "6"
}

@test "ish_stream_fold with empty input returns initial accumulator" {
  run bash -c '
    source ${ISH_CORE}/source/stream.sh
    _sum() { echo $(( $1 + $2 )); }
    printf "" | ish_stream_fold _sum 42
  '
  assert_success
  assert_output "42"
}

@test "ish_stream_bind propagates success" {
  run bash -c '
    source ${ISH_CORE}/source/stream.sh
    _double() { echo $(( $1 * 2 )); }
    printf "%s\n" "3" "5" | ish_stream_bind _double
  '
  assert_success
  assert_line --index 0 "6"
  assert_line --index 1 "10"
}

@test "ish_stream_bind short-circuits on failure" {
  run bash -c '
    source ${ISH_CORE}/source/stream.sh
    _fail_on_bad() {
      if [[ "$1" == "bad" ]]; then return 1; fi
      printf "%s\n" "ok:$1"
    }
    printf "%s\n" "good" "bad" "good" | ish_stream_bind _fail_on_bad
  '
  assert_failure
  assert_output "ok:good"
}

@test "ish_stream_stdout outputs to stdout" {
  run bash -c 'source ${ISH_CORE}/source/stream.sh; ish_stream_stdout "hello"'
  assert_success
  assert_output "hello"
}

@test "ish_stream_stderr outputs to stderr" {
  run bash -c 'source ${ISH_CORE}/source/stream.sh; ish_stream_stderr "hello" 2>&1'
  assert_success
  assert_output "hello"
}

@test "ish_stream_map requires function argument" {
  run bash -c 'source ${ISH_CORE}/source/stream.sh; ish_stream_map 2>&1'
  assert_failure
  assert_output --partial "ish_stream:"
}
