#!/usr/bin/env bash

# tui template module - string templating and file output
# provides variable substitution ({{placeholder}}) and file content output
#
# dependencies: ish_tui_error, ish_file_exists
# these functions are available because tui.sh sources dependencies before this module

ish_tui_template() {
  local level="${1-}"
  local template="${2-}"
  shift 2

  while [[ $# -gt 1 ]]; do
    local key=$1
    local value=$2
    template=${template//\{\{$key\}\}/$value}
    shift 2
  done

  ish_stream_stderr "${level}${template}"
}

ish_tui_template_file() {
  local path=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --path=*)
        path="${1#*=}"
        shift
        ;;
      *)
        ish_tui_error --message="unknown option: $1"
        ;;
    esac
  done

  [[ -z "$path" ]] && ish_tui_error --message="--path required"

  if ! ish_file_exists --path="$path"; then
    if [[ ! -e "$path" ]]; then
      ish_tui_error --message="template not found: $path"
    else
      ish_tui_error --message="not a template file: $path"
    fi
  fi

  cat "$path"
}
