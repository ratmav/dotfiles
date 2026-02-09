#!/usr/bin/env bash

kanban_module_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source "${ISH_PACKAGES_DIR}/ish/source/utils/tui.sh"
source "${kanban_module_dir}/kanban/task.sh"
source "${kanban_module_dir}/kanban/scratch.sh"

kanban_show() {
  local kanban_dir

  if [[ "${ISH_TESTING:-false}" == "true" ]]; then
    kanban_dir="${ISH_PACKAGES_DIR}/ish/test/fixtures/kanban"
  else
    kanban_dir="${ISH_PACKAGES_DIR}/ish/kanban"
  fi

  utils_tui_template_file --path="${kanban_dir}/board.md"
}

kanban_help() {
  utils_stream_multiline_stderr <<EOF
usage: ish kanban [command]

commands:
  show     output board.md
  task     manage tasks
  scratch  manage scratchpad
EOF
}

kanban_route() {
  case "${1-}" in
    show)
      shift
      kanban_show "$@"
      ;;
    task)
      shift
      case "${1-}" in
        list)
          shift
          kanban_task_list "$@"
          ;;
        new)
          shift
          kanban_task_new "$@"
          ;;
        delete)
          shift
          kanban_task_delete "$@"
          ;;
        show)
          shift
          kanban_task_show "$@"
          ;;
        path)
          shift
          kanban_task_path "$@"
          ;;
        help|"")
          kanban_task_help
          ;;
        *)
          utils_tui_error --message="unknown kanban task command: ${1-}"
          ;;
      esac
      ;;
    scratch)
      shift
      case "${1-}" in
        capture)
          shift
          kanban_scratch_capture "$@"
          ;;
        show)
          shift
          kanban_scratch_show "$@"
          ;;
        path)
          shift
          kanban_scratch_path "$@"
          ;;
        help|"")
          kanban_scratch_help
          ;;
        *)
          utils_tui_error --message="unknown kanban scratch command: ${1-}"
          ;;
      esac
      ;;
    help|"")
      kanban_help
      ;;
    *)
      utils_tui_error --message="unknown kanban command: ${1-}"
      ;;
  esac
}
