#!/usr/bin/env bash

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source ./bash/posix.sh

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
}

die() {
  local msg=$1
  local code=${2-1} # default exit status 1
  msg "${ERROR}$msg"
  exit "$code"
}

msg() {
  # CLEAR restores colors.
  echo >&2 -e "${1-}${CLEAR}"
}

setup_colors() {
  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    ERROR='\033[0;31m' CLEAR='\033[0m' OK='\033[0;32m' WARN='\033[0;33m'
  else
    ERROR='' CLEAR='' OK='' WARN=''
  fi
}

main() {
  setup_colors
  msg "${OK}bootstrap: start"
  main_posix
  msg "${OK}bootstrap: done"
}

main "$@"
