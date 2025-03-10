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
  rm -rf $HOME/.config/nvim
  mkdir -p $HOME/.config/nvim
  ln -s $PWD/init.lua $HOME/.config/nvim/init.lua
  msg "${OK}${FUNCNAME[0]}: symlinked nvim lua config."

  # Clean up all plugins including paq
  NVIM_PLUGIN_PATH="$HOME/.local/share/nvim/site/pack"
  rm -rf "$NVIM_PLUGIN_PATH"
  mkdir -p "$NVIM_PLUGIN_PATH/paqs/start"
  msg "${OK}${FUNCNAME[0]}: cleaned up all nvim plugins."

  # Install paq-nvim
  PAQ_PATH="$HOME/.local/share/nvim/site/pack/paqs/start/paq-nvim"
  git clone --depth=1 https://github.com/savq/paq-nvim "$PAQ_PATH" > /dev/null 2>&1
  msg "${OK}${FUNCNAME[0]}: installed paq-nvim."

  # Install plugins
  nvim --headless -c 'autocmd User PaqDoneInstall quit' -c 'PaqInstall' > /dev/null 2>&1
  msg "${OK}${FUNCNAME[0]}: installed neovim plugins."
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
