#!/usr/bin/env bash

# kanban task module - task management commands
#
# dependencies: utils_tui_error, utils_tui_template_file
# these functions are available because bash/kanban.sh sources dependencies before this module

kanban_task_help() {
  utils_stream_multiline_stderr <<EOF
usage: ish kanban task [command]

commands:
  list              list task names
  new --name=NAME   create new task
  delete --name=NAME  delete task
  show --name=NAME  output task content
  path --name=NAME  output task file path
EOF
}

kanban_task_delete() {
  local name=""
  local kanban_dir
  local task_file

  while [[ $# -gt 0 ]]; do
    case $1 in
      --name=*)
        name="${1#*=}"
        shift
        ;;
      *)
        utils_tui_error --message="unknown option: $1"
        ;;
    esac
  done

  [[ -z "$name" ]] && utils_tui_error --message="--name required"

  if [[ "${ISH_TESTING:-false}" == "true" ]]; then
    kanban_dir="${ISH_PACKAGES_DIR}/ish/test/fixtures/kanban"
  else
    kanban_dir="${script_dir}/kanban"
  fi

  task_file="${kanban_dir}/tasks/${name}.md"

  if [[ ! -f "$task_file" ]]; then
    utils_tui_error --message="task not found: $name"
  fi

  rm "$task_file"
}

kanban_task_list() {
  local kanban_dir
  local tasks_dir
  local task_file

  if [[ "${ISH_TESTING:-false}" == "true" ]]; then
    kanban_dir="${ISH_PACKAGES_DIR}/ish/test/fixtures/kanban"
  else
    kanban_dir="${script_dir}/kanban"
  fi

  tasks_dir="${kanban_dir}/tasks"

  if [[ ! -d "$tasks_dir" ]]; then
    return 0
  fi

  for task_file in "$tasks_dir"/*.md; do
    [[ -f "$task_file" ]] || continue
    basename "$task_file" .md
  done
}

kanban_task_new() {
  local name=""
  local kanban_dir
  local task_file

  while [[ $# -gt 0 ]]; do
    case $1 in
      --name=*)
        name="${1#*=}"
        shift
        ;;
      *)
        utils_tui_error --message="unknown option: $1"
        ;;
    esac
  done

  [[ -z "$name" ]] && utils_tui_error --message="--name required"

  if [[ "${ISH_TESTING:-false}" == "true" ]]; then
    kanban_dir="${ISH_PACKAGES_DIR}/ish/test/fixtures/kanban"
  else
    kanban_dir="${script_dir}/kanban"
  fi

  task_file="${kanban_dir}/tasks/${name}.md"

  if [[ -f "$task_file" ]]; then
    utils_tui_error --message="task already exists: $name"
  fi

  cat > "$task_file" <<EOF
# ${name}

**milestone:** 1

**dependencies:** none

## description

## deliverable
EOF
}

kanban_task_path() {
  local name=""
  local kanban_dir
  local task_file

  while [[ $# -gt 0 ]]; do
    case $1 in
      --name=*)
        name="${1#*=}"
        shift
        ;;
      *)
        utils_tui_error --message="unknown option: $1"
        ;;
    esac
  done

  [[ -z "$name" ]] && utils_tui_error --message="--name required"

  if [[ "${ISH_TESTING:-false}" == "true" ]]; then
    kanban_dir="${ISH_PACKAGES_DIR}/ish/test/fixtures/kanban"
  else
    kanban_dir="${script_dir}/kanban"
  fi

  task_file="${kanban_dir}/tasks/${name}.md"

  if [[ ! -f "$task_file" ]]; then
    utils_tui_error --message="task not found: $name"
  fi

  utils_stream_stdout "$task_file"
}

kanban_task_show() {
  local name=""
  local kanban_dir
  local task_file

  while [[ $# -gt 0 ]]; do
    case $1 in
      --name=*)
        name="${1#*=}"
        shift
        ;;
      *)
        utils_tui_error --message="unknown option: $1"
        ;;
    esac
  done

  [[ -z "$name" ]] && utils_tui_error --message="--name required"

  if [[ "${ISH_TESTING:-false}" == "true" ]]; then
    kanban_dir="${ISH_PACKAGES_DIR}/ish/test/fixtures/kanban"
  else
    kanban_dir="${script_dir}/kanban"
  fi

  task_file="${kanban_dir}/tasks/${name}.md"

  if [[ ! -f "$task_file" ]]; then
    utils_tui_error --message="task not found: $name"
  fi

  utils_tui_template_file --path="$task_file"
}
