#!/usr/bin/env bash

ish_ratfiles_bootstrap_posix_nix_install() {
  if ish_utils_exists_executable --executable=nix; then
    ish_tui_warn --message="${FUNCNAME[0]}: nix already installed."
  else
    if ! ish_utils_exists_executable --executable=curl; then
      ish_tui_error --message="${FUNCNAME[0]}: curl not found. Install curl first."
      return 1
    fi
    sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon
    ish_tui_info --message="${FUNCNAME[0]}: installed nix."
  fi
}

ish_ratfiles_bootstrap_posix_nix_config() {
  local nix_conf="$HOME/.config/nix/nix.conf"
  local nix_config="experimental-features = nix-command flakes"

  if ish_utils_exists_file --file="$nix_conf" && grep -q "$nix_config" "$nix_conf"; then
    ish_tui_warn --message="${FUNCNAME[0]}: nix flakes already enabled."
  else
    mkdir -p "$HOME/.config/nix"
    echo "$nix_config" > "$nix_conf"
    ish_tui_info --message="${FUNCNAME[0]}: enabled nix flakes."
  fi
}
