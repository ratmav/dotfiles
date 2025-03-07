#!/usr/bin/env bash

set -Eeuo pipefail
trap error ERR
trap interrupted SIGINT
trap terminated SIGTERM

ERROR='\033[0;31m' CLEAR='\033[0m' OK='\033[0;32m' WARN='\033[0;33m'

die() {
  local msg=$1
  local code=${2-1} # default exit status 1
  echo >&2 -e "${ERROR}$msg${CLEAR}"
  exit "$code"
}

error() {
  trap - ERR
}

interrupted() {
  trap - SIGINT
  echo >&2 -e "${WARN}interrupted.${CLEAR}"
}

terminated() {
  trap - SIGTERM
  echo >&2 -e "${ERROR}terminated.${CLEAR}"
}

msg() {
  # CLEAR restores colors.
  echo >&2 -e "${1-}${CLEAR}"
}

install_prerequisites() {
  msg "${WARN}${FUNCNAME[0]}: installing build dependencies..."

  sudo apt-get update
  sudo apt-get install -y ninja-build gettext cmake unzip curl git

  # Additional dependencies from the Neovim BUILD.md
  sudo apt-get install -y pkg-config libtool-bin g++ automake

  msg "${OK}${FUNCNAME[0]}: build prerequisites installed."
}

clone_neovim() {
  msg "${WARN}${FUNCNAME[0]}: cloning neovim repository..."

  if [ -d "$HOME/neovim" ]; then
    msg "${WARN}${FUNCNAME[0]}: neovim directory exists, removing..."
    rm -rf "$HOME/neovim"
  fi

  git clone https://github.com/neovim/neovim "$HOME/neovim"
  cd "$HOME/neovim"

  # Get the latest semantic version tag (vx.y.z format)
  # This fetches all tags, sorts them by version number (not chronologically), and gets the latest
  latest_version=$(git tag -l 'v[0-9]*.[0-9]*.[0-9]*' | sort -V | tail -n 1)

  if [ -z "$latest_version" ]; then
    die "no semantic version tags (vx.y.z) found"
  fi

  msg "${WARN}${FUNCNAME[0]}: checking out latest semantic version tag: $latest_version"

  git checkout "$latest_version"

  msg "${OK}${FUNCNAME[0]}: neovim repository cloned and latest version checked out."
}

build_neovim() {
  msg "${WARN}${FUNCNAME[0]}: building neovim..."

  cd "$HOME/neovim"
  make CMAKE_BUILD_TYPE=Release

  msg "${OK}${FUNCNAME[0]}: neovim built successfully."
}

install_neovim() {
  msg "${WARN}${FUNCNAME[0]}: installing neovim..."

  cd "$HOME/neovim"
  sudo make install

  msg "${OK}${FUNCNAME[0]}: neovim installed successfully."
}

setup_vim_plug() {
  msg "${WARN}${FUNCNAME[0]}: setting up vim-plug..."

  rm -rf $HOME/.local/share/nvim
  URL="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs -s $URL

  msg "${OK}${FUNCNAME[0]}: vim-plug installed."
}

install_plugins() {
  msg "${WARN}${FUNCNAME[0]}: installing neovim plugins..."

  # bypass terminal buffer check
  NVIM_INSTALL_MODE=1 nvim +PlugInstall +qall

  msg "${OK}${FUNCNAME[0]}: neovim plugins installed."
}

main() {
  install_prerequisites
  clone_neovim
  build_neovim
  install_neovim
  setup_vim_plug
  install_plugins
}

# Run the script
main
