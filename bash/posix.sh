#!/usr/bin/env bash

source ./bash/macos.sh
source ./bash/manjaro.sh

# TODO: ignore stdout.
posix_asdf() {
  rm -rf $HOME/.asdf
  git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf
}

posix_git() {
  git config --global core.excludesfile "$HOME/.gitignore_global"
  msg "${OK}posix: configured global gitignore."

  # TODO: maaaybe should be in a git config you can symlink to (also gpg config).
  git config --global core.editor "$(which nvim)"
  msg "${OK}posix: configured git editor."

  git config --global url."git@gitlab.com:".insteadOf "https://gitlab.com/"
  msg "${OK}posix: configured git to connect to gitlab over ssh."
}

posix_nvim() {
  rm -rf $HOME/.config/nvim
  mkdir -p $HOME/.config/nvim
  ln -s $PWD/init.vim $HOME/.config/nvim/init.vim
  msg "${OK}posix: symlinked nvim config."

  rm -rf $HOME/.local/share/nvim
  URL="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs -s $URL
  msg "${OK}posix: installed vim-plug."

  nvim +PlugInstall +qall
  msg "${OK}posix: installed neovim plugins."
}

posix_symlinks() {
  LINKS=(".bashrc" ".bash_profile" ".gitignore_global" ".hyper.js")
  for link in "${LINKS[@]}"; do
    rm -rf $HOME/$link
    ln -s $PWD/$link $HOME/$link
    msg "${OK}posix: symlinked $link"
  done
}

# TODO: ignore stdout.
posix_fonts() {
  git clone https://github.com/powerline/fonts.git --depth=1
  cd fonts
  ./install.sh
  cd ..
  rm -rf fonts
  msg "${OK}posix: installed powerline fonts."
}

main_posix() {
  posix_symlinks
  posix_git
  posix_nvim
  posix_fonts
  posix_asdf
}
