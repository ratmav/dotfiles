#!/usr/bin/env bash

#windows_chocolatey() {
#  if [[ $OSTYPE == "msys" ]]; then
#    msg "${WARN}${FUNCNAME[0]}: admin privileges required."
#    if command -v choco &> /dev/null; then
#      msg "${WARN}${FUNCNAME[0]}: chocolatey already installed"
#    else
#      install="Set-ExecutionPolicy Bypass \
#        -Scope Process \
#        -Force; \
#        [System.Net.ServicePointManager]::SecurityProtocol = \
#        [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; \
#        iex ((New-Object System.Net.WebClient).\
#        DownloadString('https://chocolatey.org/install.ps1'))"
#      powershell -command "$install"
#      msg "${OK}${FUNCNAME[0]}: installed chocolatey"
#    fi
#  else
#    die "${FUNCNAME[0]}: unsupported operating system."
#  fi
#}

#windows_git() {
#  if [[ $OSTYPE == "msys" ]]; then
#    git config --global core.excludesfile "$PWD/.gitignore_global"
#    msg "${OK}${FUNCNAME[0]}: configured global gitignore."
#
#    # TODO: maaaybe should be in a git config you can symlink to (also gpg config).
#    git config --global core.editor "$(which nvim)"
#    msg "${OK}${FUNCNAME[0]}: configured git editor."
#
#    git config --global url."git@gitlab.com:".insteadOf "https://gitlab.com/"
#    msg "${OK}${FUNCNAME[0]}: configured git to connect to gitlab over ssh."
#
#    git config core.eol lf
#    git config core.autocrlf input
#    git config --global core.eol lf
#    git config --global core.autocrlf input
#    msg "${OK}${FUNCNAME[0]}: configured git to use lf, not crlf line endings."
#  else
#    die "${FUNCNAME[0]}: unsupported operating system."
#  fi
#}

#windows_tools() {
#  if [[ $OSTYPE == "msys" ]]; then
#    msg "${WARN}${FUNCNAME[0]}: admin privileges required."
#
#    packages=("pandoc" "yq" "jq")
#    for package in "${packages[@]}"; do
#      if command -v $package &> /dev/null; then
#        msg "${WARN}${FUNCNAME[0]}: $package already installed"
#      else
#        choco install $package --yes
#        msg "${OK}${FUNCNAME[0]}: installed $package"
#      fi
#    done
#  else
#    die "${FUNCNAME[0]}: unsupported operating system."
#  fi
#}

windows_nvim() {
  if [[ $OSTYPE == "msys" ]]; then
    nvim_config=$HOME/AppData/Local/nvim
    rm -rf $nvim_config
    mkdir -p $nvim_config
    ln -s $PWD/init.vim $nvim_config/init.vim
    msg "${OK}${FUNCNAME[0]}: symlinked nvim config."

    nvim_autoload=$HOME/AppData/Local/nvim-data/site/autoload
    rm -rf $nvim_autoload
    URL="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    curl -fLo $nvim_autoload/plug.vim --create-dirs -s $URL
    msg "${OK}${FUNCNAME[0]}: installed vim-plug."

    nvim +PlugInstall +qall
    msg "${OK}${FUNCNAME[0]}: installed neovim plugins."
  else
    die "${FUNCNAME[0]}: unsupported operating system."
  fi
}

windows_wezterm() {
  if [[ $OSTYPE == "msys" ]]; then
    msg "${WARN}${FUNCNAME[0]}: admin privileges required."
    if command -v wezterm &> /dev/null; then
      wezterm_location=$(which wezterm)
      rm -rf "$wezterm_location".lua
      ln -s $PWD/.wezterm.lua "$wezterm_location".lua
      msg "${OK}${FUNCNAME[0]}: symlinked wezterm config"
    else
      msg "${WARN}${FUNCNAME[0]}: wezterm not installed"
    fi
  else
    die "${FUNCNAME[0]}: unsupported operating system."
  fi
}

main_windows() {
  if [[ $OSTYPE == "msys" ]]; then
    windows_chocolatey
    windows_tools
    windows_wezterm
    windows_git
    windows_nvim
  else
    die "${FUNCNAME[0]}: unsupported operating system."
  fi
}
