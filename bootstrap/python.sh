#!/bin/bash


install_python() {
  echo "...checking python install..."
  if brew list | grep python > /dev/null 2>&1; then
    echo "......python already installed"
  else
    brew install python
    echo "...installed python via homebrew..."
  fi
}

install_pypi() {
  for package in virtualenv pep8; do
    echo "...checking $package install..."
    if type "$package" > /dev/null 2>&1; then
      echo "......$package already installed"
    else
      source "$HOME/.bash_profile" && pip install -U "$package"
      echo "...installed $1..."
    fi
  done
}

bootstrap_python() {
  install_python
  install_pypi
}
