#!/usr/bin/env bash

nix-semantic() {
  local package version found_path found_commit

  read -p "Package name: " package
  read -p "Semantic version: " version

  if [[ -z "$package" ]] || [[ -z "$version" ]]; then
    tui_error "package name and version are required."
    return 1
  fi

  tui_info "searching for $package version $version in nixpkgs..."

  if ! found_path=$(_nix_find_package_path "$package"); then
    tui_error "...could not find package '$package'."
    return 1
  fi

  tui_info "...found $package $version at: $found_path"

  if ! found_commit=$(_nix_find_version_commit "$package" "$version" "$found_path"); then
    tui_error "...did not find $package version $version in recent commits."
    return 1
  fi

  tui_info "...found $package $version at commit $found_commit"
  _nix_print_pin_info "$package" "$version" "$found_commit"
}

nix-sync() {
  tui_info "syncing nix configuration..."
  tui_info "...updating channels"
  nix-channel --update
  tui_info "...syncing configuration"
  nix-env --set -f "${helpers_dir}/../../nix/base.nix"
}

_nix_find_package_path() {
  local package=$1
  local possible_paths=(
    "pkgs/by-name/${package:0:2}/$package/package.nix"
    "pkgs/by-name/${package:0:1}/$package/package.nix"
    "pkgs/development/tools/$package/default.nix"
    "pkgs/applications/misc/$package/default.nix"
    "pkgs/tools/misc/$package/default.nix"
    "pkgs/development/python-modules/$package/default.nix"
  )

  for path in "${possible_paths[@]}"; do
    if tui_quiet "curl -s -f https://api.github.com/repos/NixOS/nixpkgs/contents/$path"; then
      echo "$path"
      return 0
    fi
  done
  return 1
}

_nix_get_package_commits() {
  local path=$1
  curl -s "https://api.github.com/repos/NixOS/nixpkgs/commits?path=$path&per_page=50" | \
    grep '"sha":' | cut -d'"' -f4
}

_nix_get_version_from_commit() {
  local commit=$1 path=$2
  curl -s "https://raw.githubusercontent.com/NixOS/nixpkgs/$commit/$path" | \
    grep -E 'version\s*=' | head -1 | \
    sed 's/.*version = "\([^"]*\)".*/\1/' 2>/dev/null || echo ""
}

_nix_find_version_commit() {
  local package=$1 version=$2 path=$3
  local commits

  commits=$(_nix_get_package_commits "$path")
  for commit in $commits; do
    local found_version
    found_version=$(_nix_get_version_from_commit "$commit" "$path")
    if [[ "$found_version" == "$version" ]]; then
      echo "$commit"
      return 0
    fi
  done
  return 1
}

_nix_print_pin_info() {
  local package=$1 version=$2 commit=$3

  local template='to pin this version in your nix config:

{ pkgs ? import (
    fetchTarball "https://github.com/NixOS/nixpkgs/archive/{{commit}}.tar.gz"
  ) {}
}:

with pkgs; [
  {{package}}    # This will be {{package}} {{version}}
]'

  tui_template "${TUI_INFO}" "$template" package "$package" version "$version" commit "$commit"
}
