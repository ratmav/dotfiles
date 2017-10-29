#!/bin/bash


pypi_packages() {
  packages=(pip setuptools)
  for package in ${packages[@]}; do
    pip install -U "$package"
  done
}
