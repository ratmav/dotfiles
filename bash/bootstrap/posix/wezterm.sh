#!/usr/bin/env bash

bootstrap_posix_wezterm_configure() {
  rm -f $HOME/.wezterm.lua
  cp ./wezterm.lua $HOME/.wezterm.lua
  utils_tui_info --message="${FUNCNAME[0]}: configured wezterm."
}
