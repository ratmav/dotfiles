#!/usr/bin/env bash

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source ./bash/posix.sh
source ./bash/macos.sh
source ./bash/debian.sh

bootstrap() {
  if [[ $(uname) == "Darwin" ]]; then
    main_macos
    main_posix
  elif cat /etc/issue | grep "Debian" > /dev/null 2>&1; then
    main_debian
    main_posix
  else
    die "unsupported operating system."
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
    --oni) main_oni ;;
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
Usage: $(basename "${BASH_SOURCE[0]}") [--help] [--bootstrap] [--oni]

personal development environment on posix-compliant systems.

Available flags (choose one):

--help      Print this help and exit
--bootstrap run os setup then generic posix setup
--oni       builds the oni editor from source

note that --oni requires a full bootstrapping process.
EOF
  exit
}

main() {
  setup_colors
  parse_params "$@"
}

main "$@"
