#!/usr/bin/env bash

# tui template module - string templating and file output
# provides variable substitution ({{placeholder}}) and file content output
#
# dependencies: utils_utils_tui_error, ish_utils_exists_file
# these functions are available because bash/utils/tui.sh sources dependencies before this module

ish_utils_tui_template() {
  local level="${1-}"
  local template="${2-}"
  shift 2

  while [[ $# -gt 1 ]]; do
    local key=$1
    local value=$2
    template=${template//\{\{$key\}\}/$value}
    shift 2
  done

  ish_utils_stream_stderr "${level}${template}"
}

ish_utils_tui_template_file() {
  local path=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --path=*)
        path="${1#*=}"
        shift
        ;;
      *)
        ish_utils_tui_error --message="unknown option: $1"
        ;;
    esac
  done

  [[ -z "$path" ]] && ish_utils_tui_error --message="--path required"

  if ! ish_utils_exists_file --file="$path"; then
    if [[ ! -e "$path" ]]; then
      ish_utils_tui_error --message="template not found: $path"
    else
      ish_utils_tui_error --message="not a template file: $path"
    fi
  fi

  cat "$path"
}
