#!/usr/bin/env bash

bootstrap_kali_module_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source "${ISH_PACKAGES_DIR}/ish/source/utils/tui.sh"
source "${ISH_PACKAGES_DIR}/ish/source/platform.sh"
source "${ISH_PACKAGES_DIR}/ish/source/utils.sh"
source "${bootstrap_kali_module_dir}/posix.sh"

bootstrap_kali_all() {
  bootstrap_kali_apt
  bootstrap_kali_rust
  bootstrap_kali_wezterm
  bootstrap_posix_all
}

bootstrap_kali_apt() {
  if [[ $(platform_os) != "kali" ]]; then
    utils_tui_error --message="${FUNCNAME[0]}: unsupported operating system."
  fi

  packages=("curl" "neovim" "direnv")

  utils_tui_quiet "sudo apt-get update"

  for package in "${packages[@]}"; do
    utils_tui_quiet "sudo apt-get install -y $package"
    utils_tui_info --message="${FUNCNAME[0]}: installed $package."
  done
}

bootstrap_kali_rust() {
  if [[ $(platform_os) != "kali" ]]; then
    utils_tui_error --message="${FUNCNAME[0]}: unsupported operating system."
  fi

  if utils_exists_executable --executable=cargo; then
    utils_tui_warn --message="${FUNCNAME[0]}: rust/cargo already installed."
  else
    if ! utils_exists_executable --executable=curl; then
      utils_tui_error --message="${FUNCNAME[0]}: curl not found. Install curl first."
    fi
    curl --proto '=https' -tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    utils_tui_info --message="${FUNCNAME[0]}: installed rust/cargo."
  fi
}

bootstrap_kali_wezterm() {
  if [[ $(platform_os) != "kali" ]]; then
    utils_tui_error --message="${FUNCNAME[0]}: unsupported operating system."
  fi

  if utils_exists_executable --executable=wezterm; then
    utils_tui_warn --message="${FUNCNAME[0]}: wezterm already installed."
  else
    if ! utils_exists_executable --executable=curl; then
      utils_tui_error --message="${FUNCNAME[0]}: curl not found. Install curl first."
    fi

    local gpg_key_url="https://apt.fury.io/wez"
    local gpg_key_path="/etc/apt/keyrings/wezterm-fury.gpg"
    local apt_source_content="deb [signed-by=$gpg_key_path] $gpg_key_url/ * *"
    local apt_source_path="/etc/apt/sources.list.d/wezterm.list"

    curl -fsSL "$gpg_key_url/gpg.key" | sudo gpg --yes --dearmor -o "$gpg_key_path"
    echo "$apt_source_content" | sudo tee "$apt_source_path" > /dev/null

    sudo apt-get update
    sudo apt-get install wezterm -y

    utils_tui_info --message="${FUNCNAME[0]}: installed wezterm."
  fi
}

bootstrap_kali_help() {
  utils_stream_multiline_stderr <<EOF
usage: ish bootstrap kali [command]

commands:
  all          run all kali bootstrap steps
  apt          install system packages
  rust         install rust/cargo
  wezterm      install wezterm
EOF
}

bootstrap_kali_route() {
  case "${1-}" in
  all)
    bootstrap_kali_all
    ;;
  apt)
    shift
    bootstrap_kali_apt
    ;;
  rust)
    shift
    bootstrap_kali_rust
    ;;
  wezterm)
    shift
    bootstrap_kali_wezterm
    ;;
  help|"")
    bootstrap_kali_help
    ;;
  *)
    bootstrap_kali_help
    utils_tui_error --message="unknown kali subcommand: ${1-}"
    ;;
  esac
}
