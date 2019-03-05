#!/bin/bash

source ./bash/mac_os.sh
source ./bash/linux.sh

LINKS=(
  ".bashrc"
  ".bash_profile"
  ".tmux.conf"
  ".gitignore_global"
  ".hyper.js"
  )

configure_gitignore() {
  echo "...(re)configuring global gitignore"
  git config --global core.excludesfile "$HOME/.gitignore_global"
}

configure_git_editor() {
  echo "...(re)configuring git editor"
  git config --global core.editor "$(which nvim)"
}

home_symlinks() {
  echo "...(re)building symlinks"
  for link in "${LINKS[@]}"; do
    rm -rf $HOME/$link
    ln -s $PWD/$link $HOME/$link
    echo "......(re)built $link"
  done
}

nvim_symlink() {
  echo "...(re)building nvim init symlink"
  rm -rf $HOME/.config/nvim
  mkdir -p $HOME/.config/nvim
  ln -s $PWD/init.vim $HOME/.config/nvim/init.vim
}

operating_system() {
  if [[ $(uname) == "Darwin" ]]; then
    bootstrap_mac_os
  elif [[ $(uname) == "Linux" ]]; then
    bootstrap_linux
  fi
}

vim_plug() {
  if [ ! -d "$HOME/.local/share/nvim" ]; then
    echo "...installing vim-plug"
    URL="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs -s $URL
  fi
}

tpm() {
  if [ ! -d "$HOME/.tmux/plugins" ]; then
    echo "...installing tpm"
    mkdir -p ~/.tmux/plugins
    git clone -q https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  fi
}

nvm() {
  if [ ! -d "$HOME/.nvm" ]; then
    echo "...installing nvm"
    URL="https://raw.githubusercontent.com/creationix/nvm/master/install.sh"
    curl -o- -s $URL | bash 1>/dev/null
  fi
}

gvm() {
  if [ ! -d "$HOME/.gvm" ]; then
    echo "...installing gvm"
    URL="https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/"
    URL+="gvm-installer"
    bash < <(curl -s -S -L $URL) 1>/dev/null
  fi
}

main() {
  operating_system
  tpm
  nvm
  gvm
  vim_plug
  nvim_symlink
  home_symlinks
  configure_gitignore
  configure_git_editor
}

main "$@"
