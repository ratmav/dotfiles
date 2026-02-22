#!/usr/bin/env bash

ish_ratfiles_module_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source "${ISH_CORE}/source/tui.sh"
source "${ISH_CORE}/source/utils.sh"

source "${ish_ratfiles_module_dir}/test.sh"
source "${ish_ratfiles_module_dir}/lint.sh"
source "${ish_ratfiles_module_dir}/bootstrap.sh"
source "${ish_ratfiles_module_dir}/git.sh"
source "${ish_ratfiles_module_dir}/nix.sh"

ish_ratfiles_help() {
  ish_stream_multiline_stderr <<EOF

                  ..     .:...  .:.  :.
            ..  .:o:... ...:o:  .::oO8O
                ..:::....  ..   oOO88O.
                   .:OOOOOOOoo:.o8888:
                    .ooO8888888OO8OO8o
                        .:oOOOO8OO888O
                           :OO8888888O:
                          .O8O::oO88o:o
                          ..oO.  .::.:o
                        .:.:O88o...   .
                        :OOOOO88Oo::::o
                     :o. .ooOOO888O8OOO:
                   .oOOo::..oOOOOOOooOO8o.
                  :oOooOOOo. .oOoo:.. .oO:.
 ....            :oooooooooo::oooO.    .OoO.
:   ::o         :oOooo...:oooOOOOOo    ..::.
      o::.     .oOOOOoo:...:oOOOOOo
        o::.    .OOOOOOOo:..oOOOOo.
          :Oo.   :oOOOOOOo..O8OO:
            :::::::OOOOOOo:oOOo:
               .::ooOOOOo:oOooo::

usage: ish ratfiles [command]

(rat)mav's dot(files)

commands:
  bootstrap    setup development environment
  git          git utility functions
  lint         run linters for ratfiles package
  nix          nix package manager utilities
  test         run tests for ratfiles package
EOF
}

ish_ratfiles_route() {
  case "${1-}" in
  test)
    shift
    ish_ratfiles_test_route "$@"
    ;;
  lint)
    shift
    ish_ratfiles_lint_route "$@"
    ;;
  bootstrap)
    shift
    ish_ratfiles_bootstrap_route "$@"
    ;;
  git)
    shift
    ish_ratfiles_git_route "$@"
    ;;
  nix)
    shift
    ish_ratfiles_nix_route "$@"
    ;;
  help|"")
    ish_ratfiles_help
    ;;
  *)
    ish_ratfiles_help
    ish_tui_error --message="unknown ratfiles command: ${1-}"
    return 1
    ;;
  esac
}
