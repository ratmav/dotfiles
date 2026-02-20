#!/usr/bin/env bash

ish_ratfiles_bootstrap_posix_module_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source "${ISH_CORE}/source/tui.sh"
source "${ISH_CORE}/source/utils.sh"

source "${ish_ratfiles_bootstrap_posix_module_dir}/posix/nix.sh"
source "${ish_ratfiles_bootstrap_posix_module_dir}/posix/git.sh"
source "${ish_ratfiles_bootstrap_posix_module_dir}/posix/wezterm.sh"
source "${ish_ratfiles_bootstrap_posix_module_dir}/posix/nvim.sh"

ish_ratfiles_bootstrap_posix_all() {
  ish_ratfiles_bootstrap_posix_nix_install
  ish_ratfiles_bootstrap_posix_nix_config
  ish_ratfiles_bootstrap_posix_symlinks
  ish_ratfiles_bootstrap_posix_wezterm_configure
  ish_ratfiles_bootstrap_posix_git_configure
  ish_ratfiles_bootstrap_posix_nvim_clean
  ish_ratfiles_bootstrap_posix_nvim_configure
  ish_ratfiles_bootstrap_posix_nvim_plugins
}

ish_ratfiles_bootstrap_posix_symlinks() {
  LINKS=(".bashrc" ".bash_profile" ".gitignore_global")
  for link in "${LINKS[@]}"; do
    rm -rf $HOME/$link
    ln -s $PWD/$link $HOME/$link
    ish_tui_info --message="${FUNCNAME[0]}: symlinked $link"
  done
}

ish_ratfiles_bootstrap_posix_help() {
  ish_stream_multiline_stderr <<EOF
usage: ish ratfiles bootstrap posix [command]

commands:
  all          run all posix bootstrap steps
  nix          install and configure nix
  git          configure git settings
  wezterm      configure wezterm
  nvim         setup neovim
  symlinks     create dotfile symlinks
EOF
}

ish_ratfiles_bootstrap_posix_route() {
  case "${1-}" in
  all)
    ish_ratfiles_bootstrap_posix_all
    ;;
  nix)
    shift
    ish_ratfiles_bootstrap_posix_nix_install
    ish_ratfiles_bootstrap_posix_nix_config
    ;;
  git)
    shift
    ish_ratfiles_bootstrap_posix_git_configure
    ;;
  wezterm)
    shift
    ish_ratfiles_bootstrap_posix_wezterm_configure
    ;;
  nvim)
    shift
    ish_ratfiles_bootstrap_posix_nvim_clean
    ish_ratfiles_bootstrap_posix_nvim_configure
    ish_ratfiles_bootstrap_posix_nvim_plugins
    ;;
  symlinks)
    shift
    ish_ratfiles_bootstrap_posix_symlinks
    ;;
  help|"")
    ish_ratfiles_bootstrap_posix_help
    ;;
  *)
    ish_tui_error --message="unknown posix subcommand: ${1-}"
    ish_ratfiles_bootstrap_posix_help
    return 1
    ;;
  esac
}
