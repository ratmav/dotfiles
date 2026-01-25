#!/usr/bin/env/bash

# Color setup
setup_colors() {
  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    ERROR='\033[0;31m' CLEAR='\033[0m' OK='\033[0;32m' WARN='\033[0;33m'
  else
    ERROR='' CLEAR='' OK='' WARN=''
  fi
}

# Message output
msg() {
  # CLEAR restores colors.
  echo >&2 -e "${1-}${CLEAR}"
}

# Exit with error
die() {
  local msg=$1
  local code=${2-1} # default exit status 1
  msg "${ERROR}$msg"
  exit "$code"
}

# Run command quietly
quiet() {
  $1 > /dev/null
}

# Platform detection
_is_kali(){
  if [[ -f /etc/issue ]]; then
    if grep -q "Kali" /etc/issue; then
      return 0
    else
      return 1
    fi
  else
    return 1
  fi
}

