#!/usr/bin/env bash

ish_ratfiles_bootstrap_posix_wezterm_configure() {
  rm -f $HOME/.wezterm.lua
  cp ./wezterm.lua $HOME/.wezterm.lua
  ish_tui_info --message="${FUNCNAME[0]}: configured wezterm."
}
