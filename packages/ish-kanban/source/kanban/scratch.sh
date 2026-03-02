#!/usr/bin/env bash

# kanban scratch module - scratch file commands
#
# dependencies: ish_tui_template_file
# these functions are available because kanban.sh sources dependencies before this module

ish_kanban_scratch_help() {
  ish_stream_multiline_stderr <<EOF
usage: ish kanban scratch [command]

commands:
  capture --message=TEXT   append quick note to scratch
  show                     output scratch.md content
  path                     output scratch.md file path
EOF
}

ish_kanban_scratch_path() {
  local ish_kanban_dir
  ish_kanban_dir="$(ish_packages_data_dir "ish-kanban")"

  ish_stream_stdout "${ish_kanban_dir}/scratch.md"
}

ish_kanban_scratch_capture() {
  local message=""
  local ish_kanban_dir

  # parse options
  for arg in "$@"; do
    case "${arg}" in
      --message=*)
        message="${arg#*=}"
        ;;
      *)
        ish_tui_error --message="unknown option: ${arg}"
        ;;
    esac
  done

  # validate message
  if [[ -z "${message}" ]]; then
    ish_tui_error --message="--message is required"
  fi

  ish_kanban_dir="$(ish_packages_data_dir "ish-kanban")"

  # append to scratch.md as markdown list item
  ish_stream_stdout "- ${message}" | ish_file_append --path="${ish_kanban_dir}/scratch.md"

  ish_tui_info --message="captured: ${message}"
}

ish_kanban_scratch_show() {
  local ish_kanban_dir
  ish_kanban_dir="$(ish_packages_data_dir "ish-kanban")"

  ish_tui_template_file --path="${ish_kanban_dir}/scratch.md"
}
