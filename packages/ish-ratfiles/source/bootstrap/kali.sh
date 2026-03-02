#!/usr/bin/env bash

ish_ratfiles_bootstrap_kali_module_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source "${ISH_CORE}/source/tui.sh"
source "${ISH_CORE}/source/platform.sh"
source "${ISH_CORE}/source/result.sh"
source "${ish_ratfiles_bootstrap_kali_module_dir}/posix.sh"

ish_ratfiles_bootstrap_kali_all() {
  ish_result_and_then \
    ish_ratfiles_bootstrap_kali_apt \
    ish_ratfiles_bootstrap_kali_rust \
    ish_ratfiles_bootstrap_kali_wezterm \
    ish_ratfiles_bootstrap_posix_all
}

ish_ratfiles_bootstrap_kali_apt() {
  if [[ $(ish_platform_os) != "kali" ]]; then
    ish_tui_error --message="${FUNCNAME[0]}: unsupported operating system."
  fi

  packages=("curl" "neovim" "direnv")

  ish_tui_quiet "sudo apt-get update"

  for package in "${packages[@]}"; do
    ish_tui_quiet "sudo apt-get install -y $package"
    ish_tui_info --message="${FUNCNAME[0]}: installed $package."
  done
}

ish_ratfiles_bootstrap_kali_rust() {
  if [[ $(ish_platform_os) != "kali" ]]; then
    ish_tui_error --message="${FUNCNAME[0]}: unsupported operating system."
  fi

  if ish_exists_executable --executable=cargo; then
    ish_tui_warn --message="${FUNCNAME[0]}: rust/cargo already installed."
  else
    if ! ish_exists_executable --executable=curl; then
      ish_tui_error --message="${FUNCNAME[0]}: curl not found. Install curl first."
    fi
    curl --proto '=https' -tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    ish_tui_info --message="${FUNCNAME[0]}: installed rust/cargo."
  fi
}

ish_ratfiles_bootstrap_kali_wezterm() {
  if [[ $(ish_platform_os) != "kali" ]]; then
    ish_tui_error --message="${FUNCNAME[0]}: unsupported operating system."
  fi

  if ish_exists_executable --executable=wezterm; then
    ish_tui_warn --message="${FUNCNAME[0]}: wezterm already installed."
  else
    if ! ish_exists_executable --executable=curl; then
      ish_tui_error --message="${FUNCNAME[0]}: curl not found. Install curl first."
    fi

    local gpg_key_url="https://apt.fury.io/wez"
    local gpg_key_path="/etc/apt/keyrings/wezterm-fury.gpg"
    local apt_source_content="deb [signed-by=$gpg_key_path] $gpg_key_url/ * *"
    local apt_source_path="/etc/apt/sources.list.d/wezterm.list"

    curl -fsSL "$gpg_key_url/gpg.key" | sudo gpg --yes --dearmor -o "$gpg_key_path"
    echo "$apt_source_content" | sudo tee "$apt_source_path" > /dev/null

    sudo apt-get update
    sudo apt-get install wezterm -y

    ish_tui_info --message="${FUNCNAME[0]}: installed wezterm."
  fi
}

ish_ratfiles_bootstrap_kali_help() {
  ish_stream_multiline_stderr <<EOF
usage: ish ratfiles bootstrap kali [command]

commands:
  all          run all kali bootstrap steps
  apt          install system packages
  rust         install rust/cargo
  wezterm      install wezterm
EOF
}

ish_ratfiles_bootstrap_kali_route() {
  case "${1-}" in
  all)
    ish_ratfiles_bootstrap_kali_all
    ;;
  apt)
    shift
    ish_ratfiles_bootstrap_kali_apt
    ;;
  rust)
    shift
    ish_ratfiles_bootstrap_kali_rust
    ;;
  wezterm)
    shift
    ish_ratfiles_bootstrap_kali_wezterm
    ;;
  help|"")
    ish_ratfiles_bootstrap_kali_help
    ;;
  *)
    ish_ratfiles_bootstrap_kali_help
    ish_tui_error --message="unknown kali subcommand: ${1-}"
    ;;
  esac
}
