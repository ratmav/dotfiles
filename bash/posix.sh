#!/usr/bin/env bash

posix_asdf() {
  if [ -f "$HOME/.asdf/asdf.sh" ]; then
    msg "${OK}posix_asdf: asdf installed."
  else
    rm -rf $HOME/.asdf
    git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf > /dev/null 2>&1
    msg "${WARN}posix_asdf: asdf installed; sourcing ~/.bashrc may be required."
  fi
}

posix_node() {
  if ! [ -x "$(command -v asdf)" ]; then
    msg "${WARN}posix_node: asdf not installed. try calling posix_asdf"
  elif ! [ -d "$HOME/.asdf/installs/nodejs" ]; then
    quiet "asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git"
    quiet "asdf install nodejs latest"
    quiet "asdf global nodejs latest"
    quiet "npm install --global npm@latest"
    quiet "npm install --global yarn"
    quiet "asdf reshim"
    msg "${OK}posix_node: installed latest nodejs, npm, and yarn."
  fi
}

posix_git() {
  git config --global core.excludesfile "$HOME/.gitignore_global"
  msg "${OK}posix_git: configured global gitignore."

  # TODO: maaaybe should be in a git config you can symlink to (also gpg config).
  git config --global core.editor "$(which nvim)"
  msg "${OK}posix_git: configured git editor."

  git config --global url."git@gitlab.com:".insteadOf "https://gitlab.com/"
  msg "${OK}posix_git: configured git to connect to gitlab over ssh."
}

posix_nvim() {
  rm -rf $HOME/.config/nvim
  mkdir -p $HOME/.config/nvim
  ln -s $PWD/init.vim $HOME/.config/nvim/init.vim
  msg "${OK}posix_nvim: symlinked nvim config."

  rm -rf $HOME/.local/share/nvim
  URL="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs -s $URL
  msg "${OK}posix_nvim: installed vim-plug."

  nvim +PlugInstall +qall
  msg "${OK}posix_nvim: installed neovim plugins."
}

posix_symlinks() {
  LINKS=(".bashrc" ".bash_profile" ".gitignore_global" ".hyper.js")
  for link in "${LINKS[@]}"; do
    rm -rf $HOME/$link
    ln -s $PWD/$link $HOME/$link
    msg "${OK}posix_symlinks: symlinked $link"
  done
}

# TODO: this breaks on debian, but oni may make it obsolete.
posix_fonts() {
  git clone https://github.com/powerline/fonts.git --depth=1 > /dev/null 2>&1
  cd fonts
  ./install.sh > /dev/null 2>&1
  cd ..
  rm -rf fonts
  msg "${OK}posix_fonts: installed powerline fonts."
}

main_posix() {
  posix_symlinks
  posix_git
  posix_nvim
  posix_fonts
  posix_asdf
  posix_node
}
