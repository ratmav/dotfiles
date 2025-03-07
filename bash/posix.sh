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
  ln -s $PWD/init.vim $HOME/.config/nvim/init.vim
  msg "${OK}${FUNCNAME[0]}: symlinked nvim config."

  rm -rf $HOME/.local/share/nvim
  URL="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs -s $URL
  msg "${OK}${FUNCNAME[0]}: installed vim-plug."

  nvim +PlugInstall +qall
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
