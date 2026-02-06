#!/usr/bin/env bash

bootstrap_posix_nvim_clean() {
  local config_path="$HOME/.config/nvim"
  local nvim_plugin_path="$HOME/.local/share/nvim/site/pack"

  rm -rf $config_path
  mkdir -p $HOME/.config/nvim
  utils_tui_info --message="${FUNCNAME[0]}: removed nvim config."

  rm -rf "$nvim_plugin_path"
  mkdir -p "$nvim_plugin_path/paqs/start"
  utils_tui_info --message="${FUNCNAME[0]}: removed nvim plugins."
}

bootstrap_posix_nvim_configure() {
  if ! utils_exists_executable --executable=git; then
    utils_tui_error --message="${FUNCNAME[0]}: git not found. Install git first."
    return 1
  fi

  local paq_path="$HOME/.local/share/nvim/site/pack/paqs/start/paq-nvim"
  local paq_url="https://github.com/savq/paq-nvim"

  git clone --depth=1 "$paq_url" "$paq_path" > /dev/null 2>&1
  utils_tui_info --message="${FUNCNAME[0]}: installed paq-nvim."

  # Create symlink to main neovim config
  ln -s "$PWD/neovim.lua" "$HOME/.config/nvim/init.lua"
  utils_tui_info --message="${FUNCNAME[0]}: symlinked nvim config."
}

bootstrap_posix_nvim_plugins() {
  local plugin_init="$PWD/neovim/plugins/init.lua"

  # Launch Neovim to install plugins with timeout
  timeout 30 nvim --headless \
    -c "lua dofile('$plugin_init')" \
    -c "lua require('paq').install()" \
    -c qa
  plugin_result=$?

  if [ $plugin_result -ne 0 ]; then
    utils_tui_error --message="${FUNCNAME[0]}: plugin installation timed out."
    return 1
  fi

  utils_tui_info --message="${FUNCNAME[0]}: installed neovim plugins."
}
