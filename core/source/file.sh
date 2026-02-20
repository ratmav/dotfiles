#!/usr/bin/env bash

# Primitive layer. Built on file_descriptor.
# Persistent I/O endpoints: read, write, append, exists for files.

ish_file_module_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source "${ish_file_module_dir}/file_descriptor.sh"

ish_file_append() {
  local path=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --path=*) path="${1#*=}"; shift ;;
      *) _file_error "unknown option: $1" ;;
    esac
  done

  [[ -z "$path" ]] && _file_error "--path= required"

  cat >> "$path" || return 1
}

ish_file_bind() {
  local func="${1-}"

  [[ -z "$func" ]] && _file_error "--func required as first argument"

  local line
  while IFS= read -r line; do
    "$func" "$line" || return $?
  done
}

ish_file_exists() {
  local path=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --path=*) path="${1#*=}"; shift ;;
      *) _file_error "unknown option: $1" ;;
    esac
  done

  [[ -z "$path" ]] && _file_error "--path= required"

  [[ -f "$path" ]]
}

ish_file_read() {
  local path=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --path=*) path="${1#*=}"; shift ;;
      *) _file_error "unknown option: $1" ;;
    esac
  done

  [[ -z "$path" ]] && _file_error "--path= required"
  [[ -f "$path" ]] || _file_error "file not found: $path"

  cat "$path"
}

ish_file_require() {
  local path=""
  local message=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --path=*) path="${1#*=}"; shift ;;
      --message=*) message="${1#*=}"; shift ;;
      *) _file_error "unknown option: $1" ;;
    esac
  done

  [[ -z "$path" ]] && _file_error "--path= required"
  [[ -z "$message" ]] && message="required file not found: $path"

  [[ -f "$path" ]] || _file_error "$message"
}

ish_file_write() {
  local path=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --path=*) path="${1#*=}"; shift ;;
      *) _file_error "unknown option: $1" ;;
    esac
  done

  [[ -z "$path" ]] && _file_error "--path= required"

  local dir tmp
  dir=$(dirname "$path")
  tmp=$(mktemp "${dir}/.ish_file_write.XXXXXX") || _file_error "failed to create temp file"

  cat > "$tmp" || { rm -f "$tmp"; _file_error "failed to write temp file"; }
  mv "$tmp" "$path" || { rm -f "$tmp"; _file_error "failed to write: $path"; }
}

# Private functions

_file_error() {
  printf '%s\n' "${ISH_COLOR_RED}ish_file: ${1}${ISH_COLOR_CLEAR}" >&2
  exit 1
}
