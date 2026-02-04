#!/usr/bin/env bash

# kanban scratch module - scratch file commands
#
# dependencies: utils_tui_template_file
# these functions are available because bash/kanban.sh sources dependencies before this module

kanban_scratch_help() {
  utils_stream_multiline_stderr <<EOF
usage: ish kanban scratch [command]

commands:
  show  output scratch.md content
  path  output scratch.md file path
EOF
}

kanban_scratch_path() {
  local kanban_dir

  if [[ "${ISH_TESTING:-false}" == "true" ]]; then
    kanban_dir="${script_dir}/test/fixtures/kanban"
  else
    kanban_dir="${script_dir}/kanban"
  fi

  utils_stream_stdout "${kanban_dir}/scratch.md"
}

kanban_scratch_show() {
  local kanban_dir

  if [[ "${ISH_TESTING:-false}" == "true" ]]; then
    kanban_dir="${script_dir}/test/fixtures/kanban"
  else
    kanban_dir="${script_dir}/kanban"
  fi

  utils_tui_template_file --path="${kanban_dir}/scratch.md"
}
