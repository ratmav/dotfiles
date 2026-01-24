#!/usr/bin/env bash

macos_nix() {
  if [[ $(uname) == "Darwin" ]]; then
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

macos_nix_darwin() {
  if [[ $(uname) == "Darwin" ]]; then
    if type darwin-rebuild > /dev/null 2>&1; then
      msg "${WARN}${FUNCNAME[0]}: nix-darwin already installed."
    else
      local darwin_url="https://github.com/LnL7/nix-darwin/archive/master.tar.gz"

      quiet "nix-build $darwin_url -A installer"
      ./result/bin/darwin-installer
      msg "${OK}${FUNCNAME[0]}: installed nix-darwin."
    fi
  else
    die "${FUNCNAME[0]}: unsupported operating system."
  fi
}

macos_darwin_config() {
  if [[ $(uname) == "Darwin" ]]; then
    local config_dir="$HOME/.nixpkgs"
    local dotfiles_config="$HOME/Source/dotfiles/nix/darwin-configuration.nix"

    mkdir -p "$config_dir"
    ln -sf "$dotfiles_config" "$config_dir/darwin-configuration.nix"

    msg "${OK}${FUNCNAME[0]}: linked darwin configuration."
    msg "${WARN}${FUNCNAME[0]}: run 'darwin-rebuild switch' to activate."
  else
    die "${FUNCNAME[0]}: unsupported operating system."
  fi
}

macos_home_manager() {
  if [[ $(uname) == "Darwin" ]]; then
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

macos_home_config() {
  if [[ $(uname) == "Darwin" ]]; then
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

macos_shell() {
  if [[ $(uname) == "Darwin" ]]; then
    local bash_path="$HOME/.nix-profile/bin/bash"

    if [ ! -f "$bash_path" ]; then
      msg "${WARN}${FUNCNAME[0]}: nix bash not found. run home-manager switch first."
      return
    fi

    if ! grep -qF "$bash_path" /etc/shells; then
      echo "$bash_path" | sudo tee -a /etc/shells > /dev/null
      msg "${OK}${FUNCNAME[0]}: added nix bash to /etc/shells."
    fi

    if [ "$SHELL" != "$bash_path" ]; then
      chsh -s "$bash_path"
      msg "${OK}${FUNCNAME[0]}: changed default shell to nix bash."
      msg "${WARN}${FUNCNAME[0]}: start new shell session for changes to take effect."
    fi
  else
    die "${FUNCNAME[0]}: unsupported operating system."
  fi
}

main_macos() {
  if [[ $(uname) == "Darwin" ]]; then
    macos_nix
    macos_nix_darwin
    macos_darwin_config
    macos_home_manager
    macos_home_config
    msg "${WARN}run 'darwin-rebuild switch && home-manager switch'."
    macos_shell
  fi
}
