#!/usr/bin/env bash

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source ./bash/posix.sh
source ./bash/macos.sh
source ./bash/debian.sh

bootstrap() {
  main_posix
  if [[ $(uname) == "Darwin" ]]; then
    main_macos
  elif [[ $(uname) == "Linux" ]]; then
    msg "${WARN}main: detect debian, not just linux."
    #main_debian
  fi
}

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

parse_params() {
  args=("$@")

  [[ ${#args[@]} -ge 2 ]] && die "only one flag allowed."
  while :; do
    case "${1-}" in
    --help) usage ;;
    --bootstrap) bootstrap ;;
    --debian) main_debian ;;
    --macos) main_macos ;;
    --posix) main_posix;;
    -?*) die "unknown option: $1" ;;
    *)
      [[ ${#args[@]} -eq 0 ]] && usage
      ;;
    esac
    shift
  done

  return 0
}

setup_colors() {
  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    ERROR='\033[0;31m' CLEAR='\033[0m' OK='\033[0;32m' WARN='\033[0;33m'
  else
    ERROR='' CLEAR='' OK='' WARN=''
  fi
}

usage() {
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") [--help] [--bootstrap] [--debian] [--macos] [--posix]

personal development environment on posix-compliant systems.

Available flags (choose one):

--help      Print this help and exit
--bootstrap run posix setup then os setup
--debian    run debian setup only
--macos     run macos setup only
--posix     run posix setup only

note that the --debian and --macos setups are dependent on the posix steps being run at least once.
EOF
  exit
}

main() {
  setup_colors
  parse_params "$@"
}

main "$@"
