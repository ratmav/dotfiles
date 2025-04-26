#!/usr/bin/env bash

main_neobuild() {
  if _is_kali; then
    local current_dir=$(pwd)

    _neobuild_dependencies
    _neobuild_clone
    _neobuild_make
    _neobuild_install

    # Configure Neovim and install plugins
    posix_nvim_config "${FUNCNAME[0]}"
    posix_nvim_plugins "${FUNCNAME[0]}"

    cd "$current_dir"
  else
    die "${FUNCNAME[0]}: unsupported operating system."
  fi
}

_neobuild_clone() {
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

_neobuild_dependencies() {
  msg "${WARN}${FUNCNAME[0]}: installing build dependencies..."

  sudo apt-get update
  sudo apt-get install -y ninja-build gettext cmake unzip curl git

  # Additional dependencies from the Neovim BUILD.md
  sudo apt-get install -y pkg-config libtool-bin g++ automake

  msg "${OK}${FUNCNAME[0]}: build prerequisites installed."
}

_neobuild_install() {
  msg "${WARN}${FUNCNAME[0]}: installing neovim..."

  cd "$HOME/neovim"
  sudo make install

  msg "${OK}${FUNCNAME[0]}: neovim installed successfully."
}

_neobuild_make() {
  msg "${WARN}${FUNCNAME[0]}: building neovim..."

  cd "$HOME/neovim"
  make CMAKE_BUILD_TYPE=Release

  msg "${OK}${FUNCNAME[0]}: neovim built successfully."
}
