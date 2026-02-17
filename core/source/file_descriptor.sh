#!/usr/bin/env bash

# Foundation layer. Depends only on color.
# The POSIX I/O primitive everything else stands on.

ish_file_descriptor_module_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source "${ish_file_descriptor_module_dir}/color.sh"
ish_color_init

ish_file_descriptor_close() {
  local fd=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --fd=*) fd="${1#*=}"; shift ;;
      *) _file_descriptor_error "unknown option: $1" ;;
    esac
  done

  [[ -z "$fd" ]] && _file_descriptor_error "--fd= required"

  eval "exec ${fd}>&-" 2>/dev/null || return 1
}

ish_file_descriptor_duplicate() {
  local source=""
  local target=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --source=*) source="${1#*=}"; shift ;;
      --target=*) target="${1#*=}"; shift ;;
      *) _file_descriptor_error "unknown option: $1" ;;
    esac
  done

  [[ -z "$source" ]] && _file_descriptor_error "--source= required"
  [[ -z "$target" ]] && _file_descriptor_error "--target= required"

  eval "exec ${target}>&${source}" 2>/dev/null || return 1
}

ish_file_descriptor_open() {
  local path=""
  local fd=""
  local mode=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --path=*) path="${1#*=}"; shift ;;
      --fd=*) fd="${1#*=}"; shift ;;
      --mode=*) mode="${1#*=}"; shift ;;
      *) _file_descriptor_error "unknown option: $1" ;;
    esac
  done

  [[ -z "$path" ]] && _file_descriptor_error "--path= required"
  [[ -z "$fd" ]] && _file_descriptor_error "--fd= required"
  [[ -z "$mode" ]] && _file_descriptor_error "--mode= required (read|write|append)"

  case "$mode" in
    read)   eval "exec ${fd}<\"${path}\"" 2>/dev/null || return 1 ;;
    write)  eval "exec ${fd}>\"${path}\"" 2>/dev/null || return 1 ;;
    append) eval "exec ${fd}>>\"${path}\"" 2>/dev/null || return 1 ;;
    *) _file_descriptor_error "unknown mode: $mode (expected read|write|append)" ;;
  esac
}

ish_file_descriptor_read() {
  local fd=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --fd=*) fd="${1#*=}"; shift ;;
      *) _file_descriptor_error "unknown option: $1" ;;
    esac
  done

  [[ -z "$fd" ]] && _file_descriptor_error "--fd= required"

  local line
  while IFS= read -r -u "$fd" line; do
    printf '%s\n' "$line"
  done
}

ish_file_descriptor_require() {
  local fd=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --fd=*) fd="${1#*=}"; shift ;;
      *) _file_descriptor_error "unknown option: $1" ;;
    esac
  done

  [[ -z "$fd" ]] && _file_descriptor_error "--fd= required"

  { true >&"$fd"; } 2>/dev/null || _file_descriptor_error "fd $fd is not open"
}

ish_file_descriptor_write() {
  local fd=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --fd=*) fd="${1#*=}"; shift ;;
      *) _file_descriptor_error "unknown option: $1" ;;
    esac
  done

  [[ -z "$fd" ]] && _file_descriptor_error "--fd= required"

  local line
  while IFS= read -r line; do
    printf '%s\n' "$line" >&"$fd" || return 1
  done
}

# Private functions

_file_descriptor_error() {
  printf '%s\n' "${ISH_COLOR_RED}ish_file_descriptor: ${1}${ISH_COLOR_CLEAR}" >&2
  exit 1
}
