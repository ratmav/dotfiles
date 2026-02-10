#!/usr/bin/env bash

bootstrap_posix_module_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source "${ISH_PACKAGES_DIR}/ish/source/utils/tui.sh"
source "${ISH_PACKAGES_DIR}/ish/source/utils.sh"

source "${bootstrap_posix_module_dir}/posix/nix.sh"
source "${bootstrap_posix_module_dir}/posix/git.sh"
source "${bootstrap_posix_module_dir}/posix/wezterm.sh"
source "${bootstrap_posix_module_dir}/posix/nvim.sh"

bootstrap_posix_all() {
  bootstrap_posix_nix_install
  bootstrap_posix_nix_config
  bootstrap_posix_symlinks
  bootstrap_posix_wezterm_configure
  bootstrap_posix_git_configure
  bootstrap_posix_nvim_clean
  bootstrap_posix_nvim_configure
  bootstrap_posix_nvim_plugins
}

bootstrap_posix_symlinks() {
  LINKS=(".bashrc" ".bash_profile" ".gitignore_global")
  for link in "${LINKS[@]}"; do
    rm -rf $HOME/$link
    ln -s $PWD/$link $HOME/$link
    ish_utils_tui_info --message="${FUNCNAME[0]}: symlinked $link"
  done
}

bootstrap_posix_help() {
  ish_utils_stream_multiline_stderr <<EOF
usage: ish dotfiles bootstrap posix [command]

commands:
  all          run all posix bootstrap steps
  nix          install and configure nix
  git          configure git settings
  wezterm      configure wezterm
  nvim         setup neovim
  symlinks     create dotfile symlinks
EOF
}

bootstrap_posix_route() {
  case "${1-}" in
  all)
    bootstrap_posix_all
    ;;
  nix)
    shift
    bootstrap_posix_nix_install
    bootstrap_posix_nix_config
    ;;
  git)
    shift
    bootstrap_posix_git_configure
    ;;
  wezterm)
    shift
    bootstrap_posix_wezterm_configure
    ;;
  nvim)
    shift
    bootstrap_posix_nvim_clean
    bootstrap_posix_nvim_configure
    bootstrap_posix_nvim_plugins
    ;;
  symlinks)
    shift
    bootstrap_posix_symlinks
    ;;
  help|"")
    bootstrap_posix_help
    ;;
  *)
    ish_utils_tui_error --message="unknown posix subcommand: ${1-}"
    bootstrap_posix_help
    return 1
    ;;
  esac
}
