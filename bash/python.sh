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
  packages=(pip setuptools virtualenv flake8 pytest jedi json-rpc
            service_factory ansible)
  for package in ${packages[@]}; do
    echo "...checking $package install..."
    if type "$package" > /dev/null 2>&1; then
      echo "......$package already installed"
    else
      source "$HOME/.bashrc" && pip install -U "$package"
      echo "...installed $1..."
    fi
  done
}

bootstrap_python() {
  install_python
  install_pypi
}
