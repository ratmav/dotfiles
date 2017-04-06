#!/bin/bash


copy_fonts_linux() {
  echo "...copying fonts on linux..."
  cp -R fonts ~/.fonts
  fc-cache -f -v
  echo "......copied fonts"
}

bootstrap_linux() {
  copy_fonts_linux
}
