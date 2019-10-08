#!/bin/bash


install_homebrew() {
  echo "...checking homebrew install..."
  if type brew > /dev/null 2>&1; then
    echo "......homebrew already installed"
  else
    URL="https://raw.githubusercontent.com/Homebrew/install/master/install"
    /usr/bin/ruby -e "$(curl -fsSL $URL)"
    echo "......installed homebrew"
  fi
}

homebrew() {
  PACKAGES=("git" "bash-completion" "shellcheck")
  for package in "${PACKAGES[@]}"; do
    echo "...checking $package install..."
    if brew list | grep $package > /dev/null 2>&1; then
      echo "......$package already installed"
    else
      brew install $package
      echo "...installed $package via homebrew..."
    fi
  done
}

casks() {
  CASKS=("spectacle" "brave-browser" "vscodium")
  for cask in "${CASKS[@]}"; do
    echo "...(re)installing $cask"
    brew cask reinstall $cask --force 1>/dev/null
  done
}

press_and_hold() {
  defaults write com.visualstudio.code.oss ApplePressAndHoldEnabled -bool false
}

vscodium_settings() {
  $SETTINGS_DIRECTORY="$HOME/Library/Application\ Support/VSCodium/User/"
  mkdir -p $SETTINGS_DIRECTORY
  if [ ! -d "$SETTINGS_DIRECTORY/settings.json" ]; then
    ln -s $PWD/settings.json $SETTINGS_DIRECTORY/settings.json
  fi
}

bootstrap_mac_os() {
  install_homebrew
  homebrew
  casks
  press_and_hold
  vscodium_settings
}
