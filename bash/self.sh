#!/usr/bin/env bash

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." &>/dev/null && pwd -P)
self_module_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source "${script_dir}/bash/utils/tui.sh"
source "${script_dir}/bash/utils.sh"

source "${self_module_dir}/self/test.sh"
source "${self_module_dir}/self/lint.sh"

self_help() {
  utils_stream_multiline_stderr <<EOF
usage: ish self [command]

commands:
  test         run tests
  lint         run linters
EOF
}

self_route() {
  case "${1-}" in
  test)
    shift
    case "${1-}" in
      all)
        shift
        self_test_all "$@"
        ;;
      unit)
        shift
        self_test_unit "$@"
        ;;
      integration)
        shift
        self_test_integration "$@"
        ;;
      "")
        utils_stream_multiline_stderr <<EOF
usage: ish self test [suite] [options]

suites:
  all          run all tests
  unit         run unit tests only
  integration  run integration tests only

options:
  --route=PATH    run specific test file (e.g., tui/template)
EOF
        ;;
      *)
        utils_tui_error --message="unknown test suite: ${1-}"
        return 1
        ;;
    esac
    ;;
  lint)
    shift
    case "${1-}" in
      all)
        shift
        self_lint_all
        ;;
      bash)
        shift
        self_lint_bash
        ;;
      "")
        utils_stream_multiline_stderr <<EOF
usage: ish self lint [target]

targets:
  all          lint all files
  bash         lint bash scripts only
EOF
        ;;
      *)
        utils_tui_error --message="unknown lint target: ${1-}"
        return 1
        ;;
    esac
    ;;
  help|"")
    self_help
    ;;
  *)
    utils_tui_error --message="unknown self command: ${1-}"
    self_help
    return 1
    ;;
  esac
}
