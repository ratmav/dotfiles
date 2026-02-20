#!/usr/bin/env bash

# kanban task module - task management commands
#
# dependencies: ish_tui_error, ish_tui_template_file
# these functions are available because kanban.sh sources dependencies before this module

ish_kanban_task_help() {
  ish_stream_multiline_stderr <<EOF
usage: ish kanban task [command]

commands:
  list              list task names
  new --name=NAME   create new task
  delete --name=NAME  delete task
  show --name=NAME  output task content
  path --name=NAME  output task file path
EOF
}

ish_kanban_task_delete() {
  local name=""
  local ish_kanban_dir
  local task_file

  while [[ $# -gt 0 ]]; do
    case $1 in
      --name=*)
        name="${1#*=}"
        shift
        ;;
      *)
        ish_tui_error --message="unknown option: $1"
        ;;
    esac
  done

  [[ -z "$name" ]] && ish_tui_error --message="--name required"

  if [[ "${ISH_TESTING:-false}" == "true" ]]; then
    ish_kanban_dir="${ISH_PACKAGES}/ish-kanban/test/fixtures"
  else
    ish_kanban_dir="${ISH_PACKAGES}/ish-kanban/data"
  fi

  task_file="${ish_kanban_dir}/tasks/${name}.md"

  if [[ ! -f "$task_file" ]]; then
    ish_tui_error --message="task not found: $name"
  fi

  rm "$task_file"
}

ish_kanban_task_list() {
  local ish_kanban_dir
  local tasks_dir
  local task_file

  if [[ "${ISH_TESTING:-false}" == "true" ]]; then
    ish_kanban_dir="${ISH_PACKAGES}/ish-kanban/test/fixtures"
  else
    ish_kanban_dir="${ISH_PACKAGES}/ish-kanban/data"
  fi

  tasks_dir="${ish_kanban_dir}/tasks"

  if [[ ! -d "$tasks_dir" ]]; then
    return 0
  fi

  for task_file in "$tasks_dir"/*.md; do
    [[ -f "$task_file" ]] || continue
    basename "$task_file" .md
  done
}

ish_kanban_task_new() {
  local name=""
  local ish_kanban_dir
  local task_file

  while [[ $# -gt 0 ]]; do
    case $1 in
      --name=*)
        name="${1#*=}"
        shift
        ;;
      *)
        ish_tui_error --message="unknown option: $1"
        ;;
    esac
  done

  [[ -z "$name" ]] && ish_tui_error --message="--name required"

  if [[ "${ISH_TESTING:-false}" == "true" ]]; then
    ish_kanban_dir="${ISH_PACKAGES}/ish-kanban/test/fixtures"
  else
    ish_kanban_dir="${ISH_PACKAGES}/ish-kanban/data"
  fi

  task_file="${ish_kanban_dir}/tasks/${name}.md"

  if [[ -f "$task_file" ]]; then
    ish_tui_error --message="task already exists: $name"
  fi

  cat > "$task_file" <<EOF
# ${name}

**milestone:** 1

**dependencies:** none

## description

## deliverable
EOF
}

ish_kanban_task_path() {
  local name=""
  local ish_kanban_dir
  local task_file

  while [[ $# -gt 0 ]]; do
    case $1 in
      --name=*)
        name="${1#*=}"
        shift
        ;;
      *)
        ish_tui_error --message="unknown option: $1"
        ;;
    esac
  done

  [[ -z "$name" ]] && ish_tui_error --message="--name required"

  if [[ "${ISH_TESTING:-false}" == "true" ]]; then
    ish_kanban_dir="${ISH_PACKAGES}/ish-kanban/test/fixtures"
  else
    ish_kanban_dir="${ISH_PACKAGES}/ish-kanban/data"
  fi

  task_file="${ish_kanban_dir}/tasks/${name}.md"

  if [[ ! -f "$task_file" ]]; then
    ish_tui_error --message="task not found: $name"
  fi

  ish_stream_stdout "$task_file"
}

ish_kanban_task_show() {
  local name=""
  local ish_kanban_dir
  local task_file

  while [[ $# -gt 0 ]]; do
    case $1 in
      --name=*)
        name="${1#*=}"
        shift
        ;;
      *)
        ish_tui_error --message="unknown option: $1"
        ;;
    esac
  done

  [[ -z "$name" ]] && ish_tui_error --message="--name required"

  if [[ "${ISH_TESTING:-false}" == "true" ]]; then
    ish_kanban_dir="${ISH_PACKAGES}/ish-kanban/test/fixtures"
  else
    ish_kanban_dir="${ISH_PACKAGES}/ish-kanban/data"
  fi

  task_file="${ish_kanban_dir}/tasks/${name}.md"

  if [[ ! -f "$task_file" ]]; then
    ish_tui_error --message="task not found: $name"
  fi

  ish_tui_template_file --path="$task_file"
}
