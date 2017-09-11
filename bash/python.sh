#!/bin/bash


pypi_packages() {
  packages=(pip setuptools virtualenv pep8 powerline-status)
  for package in ${packages[@]}; do
    pip install -U "$package"
  done
}
