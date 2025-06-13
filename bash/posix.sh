#!/usr/bin/env bash

posix_asdf() {
  if [ -f "$HOME/.asdf/asdf.sh" ]; then
    msg "${WARN}${FUNCNAME[0]}: asdf installed."
  else
    rm -rf $HOME/.asdf
    git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch v0.15.0 > /dev/null 2>&1
    msg "${OK}${FUNCNAME[0]}: asdf installed."
    msg "${WARN}${FUNCNAME[0]}: sourcing ~/.bashrc may be required."
  fi
}

posix_configure_wez() {
  rm -f $HOME/.wezterm.lua
  cp ./wezterm.lua $HOME/.wezterm.lua
  msg "${OK}${FUNCNAME[0]}: configured wez."
}

posix_git() {
  git config --global core.excludesfile "$HOME/.gitignore_global"
  msg "${OK}${FUNCNAME[0]}: configured global gitignore."

  # TODO: maaaybe should be in a git config you can symlink to (also gpg config).
  git config --global core.editor "$(which nvim)"
  msg "${OK}${FUNCNAME[0]}: configured git editor."

  git config --global push.autoSetupRemote true
  msg "${OK}${FUNCNAME[0]}: configured git to automatically setup remote branches on push."
}

posix_nvim() {
  _posix_nvim_clean "${FUNCNAME[0]}"
  _posix_nvim_configure "${FUNCNAME[0]}"
}

posix_symlinks() {
  LINKS=(".bashrc" ".bash_profile" ".gitignore_global")
  for link in "${LINKS[@]}"; do
    rm -rf $HOME/$link
    ln -s $PWD/$link $HOME/$link
    msg "${OK}${FUNCNAME[0]}: symlinked $link"
  done
}

main_posix() {
  posix_symlinks
  posix_configure_wez
  posix_git
  posix_nvim
  posix_asdf
}

_posix_nvim_clean() {
  local caller="$1"
  local config_path="$HOME/.config/nvim"
  local nvim_plugin_path="$HOME/.local/share/nvim/site/pack"

  rm -rf $config_path
  mkdir -p $HOME/.config/nvim
  msg "${OK}${caller}: removed nvim config."

  rm -rf "$nvim_plugin_path"
  mkdir -p "$nvim_plugin_path/paqs/start"
  msg "${OK}${caller}: removed nvim plugins."
}

_posix_nvim_configure() {
  local caller="$1"
  local paq_path="$HOME/.local/share/nvim/site/pack/paqs/start/paq-nvim"
  local paq_url="https://github.com/savq/paq-nvim"

  git clone --depth=1 "$paq_url" "$paq_path" > /dev/null 2>&1
  msg "${OK}${caller}: installed paq-nvim."

  _posix_nvim_plugin "$caller"

  # Create symlink to main neovim config
  ln -s "$script_dir/neovim.lua" "$HOME/.config/nvim/init.lua"
  msg "${OK}${caller}: symlinked nvim config."
}

_posix_nvim_plugin() {
  local caller="$1"
  local plugin_init="$script_dir/neovim/plugins/init.lua"

  # Launch Neovim to install plugins with timeout
  timeout 30 nvim --headless \
    -c "lua dofile('$plugin_init')" \
    -c "lua require('paq').install()" \
    -c qa
  plugin_result=$?

  if [ $plugin_result -ne 0 ]; then
    die "${caller}: plugin installation timed out."
  fi

  msg "${OK}${caller}: installed neovim plugins."
}
