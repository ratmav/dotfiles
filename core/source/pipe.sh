#!/usr/bin/env bash

# Primitive layer. Built on file_descriptor.
# Process composition: connect, compose, tee with PIPESTATUS capture.

ish_pipe_module_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source "${ish_pipe_module_dir}/file_descriptor.sh"

ISH_PIPE_STATUS=()

ish_pipe_connect() {
  local cmd_a="${1-}"
  local cmd_b="${2-}"

  [[ -z "$cmd_a" ]] && _pipe_error "first command required"
  [[ -z "$cmd_b" ]] && _pipe_error "second command required"

  "$cmd_a" | "$cmd_b"
  ISH_PIPE_STATUS=("${PIPESTATUS[@]}")
}

ish_pipe_compose() {
  local -a cmds=("$@")

  [[ ${#cmds[@]} -lt 2 ]] && _pipe_error "at least two commands required"

  # FIFOs, not eval or case dispatch. eval does not preserve PIPESTATUS.
  # Case dispatch preserves PIPESTATUS but caps stage count artificially.
  # Recursive approach loses middle-stage status to subshell boundaries.
  local tmpdir
  tmpdir=$(_pipe_create_fifos "${#cmds[@]}")

  local -a pids=()
  _pipe_run_stages cmds pids "$tmpdir"

  local last_status=$?
  _pipe_collect_status pids "$last_status"

  rm -rf "$tmpdir"
}

ish_pipe_tee() {
  [[ $# -eq 0 ]] && _pipe_error "at least one destination required"

  tee "$@"
}

ish_pipe_status() {
  local code

  for code in "${ISH_PIPE_STATUS[@]}"; do
    printf '%s\n' "$code"
  done
}

ish_pipe_require_success() {
  local i
  local code

  for i in "${!ISH_PIPE_STATUS[@]}"; do
    code="${ISH_PIPE_STATUS[$i]}"
    if [[ "$code" -ne 0 ]]; then
      _pipe_error "stage $((i + 1)) failed with exit code $code"
    fi
  done
}

# Private functions

_pipe_create_fifos() {
  local stage_count="$1"
  local tmpdir i

  tmpdir=$(mktemp -d) || _pipe_error "failed to create temp directory"

  for ((i = 0; i < stage_count - 1; i++)); do
    mkfifo "${tmpdir}/pipe_${i}" || { rm -rf "$tmpdir"; _pipe_error "failed to create fifo"; }
  done

  printf '%s' "$tmpdir"
}

_pipe_run_stages() {
  local -n _cmds=$1 _pids=$2
  local tmpdir="$3"
  local i

  "${_cmds[0]}" > "${tmpdir}/pipe_0" &
  _pids+=($!)

  for ((i = 1; i < ${#_cmds[@]} - 1; i++)); do
    "${_cmds[$i]}" < "${tmpdir}/pipe_$((i - 1))" > "${tmpdir}/pipe_${i}" &
    _pids+=($!)
  done

  "${_cmds[-1]}" < "${tmpdir}/pipe_$((${#_cmds[@]} - 2))"
}

_pipe_collect_status() {
  local -n _pids_ref=$1
  local last_status="$2"
  local pid

  ISH_PIPE_STATUS=()
  for pid in "${_pids_ref[@]}"; do
    wait "$pid"
    ISH_PIPE_STATUS+=($?)
  done
  ISH_PIPE_STATUS+=("$last_status")
}

_pipe_error() {
  printf '%s\n' "${ISH_COLOR_RED}ish_pipe: ${1}${ISH_COLOR_CLEAR}" >&2
  exit 1
}
