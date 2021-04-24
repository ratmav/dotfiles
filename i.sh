#!/usr/bin/env bash

set -Eeuo pipefail
trap error ERR
trap interrupted SIGINT
trap terminated SIGTERM

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source ./bash/personal.sh
source ./bash/posix.sh
source ./bash/macos.sh
source ./bash/debian.sh

bootstrap() {
  if [[ $(uname) == "Darwin" ]]; then
    main_macos
    main_posix
  elif grep -q "Debian" /etc/issue; then
    main_debian
    main_posix
  else
    die "bootstrap: unsupported operating system."
  fi
}

call_usage() {
  msg "${WARN}function not found. available functions:"
  for function in $(compgen -A function); do
    msg "${WARN}...$function"
  done
}

die() {
  local msg=$1
  local code=${2-1} # default exit status 1
  msg "${ERROR}$msg"
  exit "$code"
}

error () {
  trap - ERR
}

interrupted() {
  trap - SIGINT
  msg "${WARN}interrupted."
}

main() {
  setup_colors
  parse_params "$@"
}

msg() {
  # CLEAR restores colors.
  echo >&2 -e "${1-}${CLEAR}"
}

parse_params() {
  args=("$@")

  while :; do
    case "${1-}" in
    --help) usage ;;
    --bootstrap) bootstrap ;;
    --call)
      if [ ! -z ${2-} ]; then
        if compgen -A function | grep $2> /dev/null 2>&1; then
          $2
        else
          call_usage
        fi
      else
        call_usage
      fi
      ;;
    -?*) die "unknown option: $1" ;;
    *)
      [[ ${#args[@]} -eq 0 ]] && usage
      ;;
    esac
    shift
  done

  return 0
}

quiet() {
  $1 > /dev/null
}

setup_colors() {
  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    ERROR='\033[0;31m' CLEAR='\033[0m' OK='\033[0;32m' WARN='\033[0;33m'
  else
    ERROR='' CLEAR='' OK='' WARN=''
  fi
}

terminated() {
  trap - SIGTERM
  msg "${ERROR}terminated."
}

usage() {
  cat <<EOF

                            .:
                            :.
                         :oo::.
           ..       ...:oOOOoo: ....           :
           oOOo::o::ooOOOOOoOO. .: .o::...:...::
           .:oo: :..:O8O:.  Oo   .  oOOOOOOOOOO:
          .oo8o. ....::Oo.  O8:     o8O8888O....
         .oOO8O.  ..::.:O:  :O:     :OOoo:.  .:O.
        .ooooo.    :OO: .:  :::::  .ooo:    o::..:
     .oooo:oo:.     .::::oOooOOOO:.:o.    .O8.   o:
   .:o:...    .   :::::oOOOOoooOOOOo::  .oo::   :Ooo:
  :O8O.      .o:.:oOOOoooo::o:::OOO:.oo:OOo    ::OOOOOo.
   .ooo::     .oOo:oOOoo::ooo: .:o::..ooo.     . .:OOO8OOo..
   .oO88O:o:  ooo::oo:ooo:::...:::..::::::        ..:ooo::
   .:O88OOOO:oOoOOoo:oo:oooo:.. .:..:oOOo.:..:.    ......
   .:oo:.   .:Oo:oooooooOOOOO:.  :o::ooo.:ooOO.  ..:..:o.
   .:.....:oo:OO:ooooo:oOOOOoo.   o. :o:.oo.:. .:  :o.oo
   :Oooo:oo:  :O:oOo:::::ooo:.   .o.  :oo:O:   .:..ooOOo
   :8Oo:...  ..o:oo::::.....     o:..:oOO:...:.:::ooOOOo
     :OOoo:...:o::::.:o:.     ..::.:::o::  .:.::::..o8Oo.
       :oooo..:o:.:::::o:..........:o:...::..oOo::o::O8O:..
         .oo...OO:. ...:.    .. .:oOo:.  :o: .o::::. .oo..::
           .:.:O8:..:..::..   ...::oOo.   ::.... .:.....
             .ooOo:oo:.:o::::..               oOo::.:o.
                ...... .:ooOo.              . .O8OOOO:
                          .o:                 .o:.o:.
                                               .oo:
                                                 ..

Usage: $(basename "${BASH_SOURCE[0]}") [--help] [--bootstrap] [--call]

personal development environment on posix-compliant systems.

Available flags (choose one):

--help       Print this help and exit.
--bootstrap  run os setup then generic posix setup.
--call \$NAME call a specific function by name. leave name blank for a list of functions.

note:
  * a shell reload/relogin is likely required after bootstrapping.
EOF
  exit
}

main "$@"
