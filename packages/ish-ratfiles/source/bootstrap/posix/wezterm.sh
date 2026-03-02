#!/usr/bin/env bash

ish_ratfiles_bootstrap_posix_wezterm_configure() {
  ish_file_read --path="./wezterm.lua" | ish_file_write --path="$HOME/.wezterm.lua"
  ish_tui_info --message="${FUNCNAME[0]}: configured wezterm."
}
