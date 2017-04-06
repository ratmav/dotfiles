#!/bin/bash


declare -a PYPI=("virtualenv" "virtualenvwrapper" "autoenv" "pep8")

install_python() {
  echo "...checking python install..."
  if brew list | grep python > /dev/null 2>&1; then
    echo "......python already installed"
  else
    brew install python
    echo "...installed livedown..."
  fi
  for package in ${PYPI[@]}; do
    echo "PACKAGE: $package"
    install_pypi $package
  done
}

install_pypi() {
  echo "...checking $1 install..."
  if type $1 > /dev/null 2>&1; then
    echo "......$1 already installed"
  else
    source $HOME/.bash_profile && pip install $1
    echo "...installed $1..."
  fi
}

bootstrap_python() {
  install_python
  install_pypi
}
