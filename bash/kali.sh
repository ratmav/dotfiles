#!/usr/bin/env bash

source ./bash/_lib.sh


kali_nix() {
  if _is_kali; then
    if type nix > /dev/null 2>&1; then
      msg "${WARN}${FUNCNAME[0]}: nix already installed."
    else
      sh <(curl -L https://nixos.org/nix/install) --daemon
      msg "${OK}${FUNCNAME[0]}: installed nix."
    fi
  else
    die "${FUNCNAME[0]}: unsupported operating system."
  fi
}

kali_nix_config() {
  if _is_kali; then
    mkdir -p ~/.config/nix
    rm -f ~/.config/nix/nix.conf
    echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
    msg "${OK}${FUNCNAME[0]}: configured nix with flakes support."
  else
    die "${FUNCNAME[0]}: unsupported operating system."
  fi
}

kali_home_manager() {
  if _is_kali; then
    if type home-manager > /dev/null 2>&1; then
      msg "${WARN}${FUNCNAME[0]}: home-manager already installed."
    else
      local hm_url="https://github.com/nix-community/home-manager/archive/master.tar.gz"
      local unstable_url="https://nixos.org/channels/nixpkgs-unstable"

      nix-channel --add "$hm_url" home-manager
      nix-channel --add "$unstable_url" nixpkgs-unstable
      quiet "nix-channel --update"
      nix-shell '<home-manager>' -A install
      msg "${OK}${FUNCNAME[0]}: installed home-manager."
    fi
  else
    die "${FUNCNAME[0]}: unsupported operating system."
  fi
}

kali_home_config() {
  if _is_kali; then
    local config_dir="$HOME/.config/home-manager"
    local dotfiles_config="$HOME/Source/dotfiles/nix/home.nix"

    mkdir -p "$config_dir"
    ln -sf "$dotfiles_config" "$config_dir/home.nix"

    msg "${OK}${FUNCNAME[0]}: linked home-manager configuration."
    msg "${WARN}${FUNCNAME[0]}: run 'home-manager switch' to activate."
  else
    die "${FUNCNAME[0]}: unsupported operating system."
  fi
}

main_kali() {
  if _is_kali; then
    kali_nix
    kali_nix_config
    kali_home_manager
    kali_home_config
    msg "${WARN}run 'home-manager switch'."
  fi
}
