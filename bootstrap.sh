#!/bin/bash

source ./bash/mac_os.sh
source ./bash/linux.sh


configure_git_editor() {
  echo "configuring git editor..."
  git config --global core.editor "$(which nvim)"
  echo "...configured"
}

configure_gitignore() {
  echo "configuring global gitignore..."
  git config --global core.excludesfile "$HOME/.gitignore_global"
  echo "...configured"
}

home_symlinks() {
  echo "checking home folder symlinks..."
  files=(".bashrc" ".bash_profile" ".gitignore_global" ".ansible.cfg")
  for file in "${files[@]}"; do
    if [[ -h ~/$file ]]; then
      echo "...link present for $file"
    else
      ln -s "$PWD/$file" "$HOME/$file"
      echo "...linked $file"
    fi
  done
}

# First parameter is the directory; second parameter is the file.
neovim_symlink() {
  echo "checking neovim $2 symlink..."
  plug="$HOME/.local/share/nvim/site/autoload/plug.vim"
  if [[ -h $1$2 ]]; then
    echo "...link present for $1$2"
  else
    mkdir -p $1
    ln -s "$PWD/$2" $1$2
    echo "...linked $2"
  fi
}

system_specific_tasks() {
  if [[ $(uname) == "Darwin" ]]; then
    echo "Running Mac-specific checks..."
    bootstrap_mac_os
  elif [[ $(uname) == "Linux" ]]; then
    echo "Running Linux-specific checks..."
    bootstrap_linux
  fi
}

main() {
  home_symlinks
  neovim_symlink "$HOME/.config/nvim/" "init.vim"
  neovim_symlink "$HOME/.local/share/nvim/site/autoload/" "plug.vim"
  configure_gitignore
  configure_git_editor
  system_specific_tasks
}

main "$@"
