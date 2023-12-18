#!/usr/bin/env/bash

source ./bash/_lib.sh

NEOVIM_VERSION="v0.9.4"
WEZTERM_VERSION="20230712-072601-f4abf8fd"

_build_neovim() {
  cd $HOME/Tools/neovim
  git reset --hard HEAD
  git checkout $NEOVIM_VERSION
  make CMAKE_BUILD_TYPE=RelWithDebInfo
  sudo make install
}

_build_wezterm() {
  cd $HOME/Tools/wezterm
  git reset --hard HEAD
  git checkout $WEZTERM_VERSION
  $HOME/Tools/wezterm/get-deps
  cargo build --release
  sudo cp $HOME/Tools/wezterm/target/release/wezterm-gui /usr/bin/wezterm
}

sid_dependencies() {
  if _is_sid; then
    packages=("ninja-build" "gettext" "cmake" "unzip" "curl")
    for package in "${packages[@]}"; do
      quiet "sudo apt install -y $package"
      msg "${OK}${FUNCNAME[0]}: installed $package."
    done
  else
    die "${FUNCNAME[0]}: unsupported operating system."
  fi
}

sid_neovim() {
  if _is_sid; then
    if type nvim > /dev/null 2>&1; then
      msg "${WARN}${FUNCNAME[0]}: neovim already installed."
    else
      if [ -d $HOME/Tools/neovim ]; then
        _build_neovim
      else
        mkdir -p $HOME/Tools
        cd $HOME/Tools
        git clone https://github.com/neovim/neovim.git
        _build_neovim
      fi
    fi
  else
    die "${FUNCNAME[0]}: unsupported operating system."
  fi
}

sid_rust() {
  if _is_sid; then
    if type cargo > /dev/null 2>&1; then
      msg "${WARN}${FUNCNAME[0]}: rust/cargo already installed."
    else
      curl --proto '=https' -tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    fi
  else
    die "${FUNCNAME[0]}: unsupported operating system."
  fi
}

sid_wezterm() {
  if _is_sid; then
    if type wezterm > /dev/null 2>&1; then
      msg "${WARN}${FUNCNAME[0]}: wezterm already installed."
    else
      if [ -d $HOME/Tools/wezterm ]; then
        _build_wezterm
      else
        mkdir -p $HOME/Tools
        cd $HOME/Tools
        git clone https://github.com/wez/wezterm.git
        _build_wezterm
      fi
    fi
  else
    die "${FUNCNAME[0]}: unsupported operating system."
  fi
}

main_sid() {
  if _is_sid; then
    sid_dependencies
    sid_neovim
    sid_rust
    sid_wezterm
  else
    die "${FUNCNAME[0]}: unsupported operating system."
  fi
}
