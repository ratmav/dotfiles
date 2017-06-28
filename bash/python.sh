#!/bin/bash


pypi_packages() {
  packages=(pip setuptools powerline-status virtualenv pep8 ansible)
  for package in ${packages[@]}; do
    pip install -U "$package"
  done
}
