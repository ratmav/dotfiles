#!/usr/bin/env bash

posix_nvim_paq() {
  local paq_path="$HOME/.local/share/nvim/site/pack/paqs/start/paq-nvim"
  local paq_url="https://github.com/savq/paq-nvim"
  local plugin_init="$HOME/Source/dotfiles/neovim/plugins/init.lua"

  if [ ! -d "$paq_path" ]; then
    mkdir -p "$(dirname "$paq_path")"
    git clone --depth=1 "$paq_url" "$paq_path" > /dev/null 2>&1
    msg "${OK}${FUNCNAME[0]}: installed paq-nvim."

    # Install plugins
    timeout 30 nvim --headless \
      -c "lua dofile('$plugin_init')" \
      -c "lua require('paq').install()" \
      -c qa
    msg "${OK}${FUNCNAME[0]}: installed neovim plugins."
  else
    msg "${WARN}${FUNCNAME[0]}: paq-nvim already installed."
  fi
}

main_posix() {
  # home-manager now handles symlinks, git config, etc.
  # Only need to install paq-nvim plugin manager
  posix_nvim_paq
}
