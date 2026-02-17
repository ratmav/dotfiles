#!/usr/bin/env bash

ish_kanban_module_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source "${ISH_CORE}/source/utils/tui.sh"
source "${ish_kanban_module_dir}/kanban/task.sh"
source "${ish_kanban_module_dir}/kanban/scratch.sh"
source "${ish_kanban_module_dir}/test.sh"

ish_kanban_show() {
  local ish_kanban_dir

  if [[ "${ISH_TESTING:-false}" == "true" ]]; then
    ish_kanban_dir="${ISH_PACKAGES}/ish-kanban/test/fixtures"
  else
    ish_kanban_dir="${ISH_PACKAGES}/ish-kanban/data"
  fi

  ish_utils_tui_template_file --path="${ish_kanban_dir}/board.md"
}

ish_kanban_help() {
  ish_utils_stream_multiline_stderr <<EOF
usage: ish kanban [command]

commands:
  show     output board.md
  task     manage tasks
  scratch  manage scratchpad
  test     run kanban tests
EOF
}

ish_kanban_route() {
  case "${1-}" in
    show)
      shift
      ish_kanban_show "$@"
      ;;
    task)
      shift
      case "${1-}" in
        list)
          shift
          ish_kanban_task_list "$@"
          ;;
        new)
          shift
          ish_kanban_task_new "$@"
          ;;
        delete)
          shift
          ish_kanban_task_delete "$@"
          ;;
        show)
          shift
          ish_kanban_task_show "$@"
          ;;
        path)
          shift
          ish_kanban_task_path "$@"
          ;;
        help|"")
          ish_kanban_task_help
          ;;
        *)
          ish_utils_tui_error --message="unknown kanban task command: ${1-}"
          ;;
      esac
      ;;
    scratch)
      shift
      case "${1-}" in
        capture)
          shift
          ish_kanban_scratch_capture "$@"
          ;;
        show)
          shift
          ish_kanban_scratch_show "$@"
          ;;
        path)
          shift
          ish_kanban_scratch_path "$@"
          ;;
        help|"")
          ish_kanban_scratch_help
          ;;
        *)
          ish_utils_tui_error --message="unknown kanban scratch command: ${1-}"
          ;;
      esac
      ;;
    test)
      shift
      ish_kanban_test_route "$@"
      ;;
    help|"")
      ish_kanban_help
      ;;
    *)
      ish_utils_tui_error --message="unknown kanban command: ${1-}"
      ;;
  esac
}
