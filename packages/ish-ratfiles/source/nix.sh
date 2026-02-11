#!/usr/bin/env bash

source "${ISH_CORE}/source/utils/tui.sh"
source "${ISH_CORE}/source/utils.sh"

# Public functions (alphabetized)

ish_ratfiles_nix_semantic() {
  local package version found_path found_commit

  read -p "Package name: " package
  read -p "Semantic version: " version

  if [[ -z "$package" ]] || [[ -z "$version" ]]; then
    ish_utils_tui_error --message="package name and version are required."
  fi

  ish_utils_tui_info --message="searching for $package version $version in nixpkgs..."

  if ! found_path=$(_nix_find_package_path "$package"); then
    ish_utils_tui_error --message="...could not find package '$package'."
  fi

  ish_utils_tui_info --message="...found $package $version at: $found_path"

  if ! found_commit=$(_nix_find_version_commit "$package" "$version" "$found_path"); then
    ish_utils_tui_error --message="...did not find $package version $version in recent commits."
  fi

  ish_utils_tui_info --message="...found $package $version at commit $found_commit"
  _nix_print_pin_info "$package" "$version" "$found_commit"
}

ish_ratfiles_nix_help() {
  ish_utils_stream_multiline_stderr <<EOF
usage: ish ratfiles nix [command]

commands:
  semantic     find nixpkgs commit for semantic version
EOF
}

ish_ratfiles_nix_route() {
  case "${1-}" in
  semantic)
    shift
    ish_ratfiles_nix_semantic "$@"
    ;;
  help|"")
    ish_ratfiles_nix_help
    ;;
  *)
    ish_utils_tui_error --message="unknown nix command: ${1-}"
    ish_ratfiles_nix_help
    return 1
    ;;
  esac
}

# Private functions (alphabetized)

_nix_find_package_path() {
  local package=$1

  if ! ish_utils_exists_executable --executable=curl; then
    ish_utils_tui_error --message="curl not found. Please install curl."
  fi

  local possible_paths=(
    "pkgs/by-name/${package:0:2}/$package/package.nix"
    "pkgs/by-name/${package:0:1}/$package/package.nix"
    "pkgs/development/tools/$package/default.nix"
    "pkgs/applications/misc/$package/default.nix"
    "pkgs/tools/misc/$package/default.nix"
    "pkgs/development/python-modules/$package/default.nix"
  )

  for path in "${possible_paths[@]}"; do
    if ish_utils_tui_quiet "curl -s -f https://api.github.com/repos/NixOS/nixpkgs/contents/$path"; then
      ish_utils_tui_info --message="$path"
      return 0
    fi
  done
  return 1
}

_nix_find_version_commit() {
  local package=$1 version=$2 path=$3
  local commits

  commits=$(_nix_get_package_commits "$path")
  for commit in $commits; do
    local found_version
    found_version=$(_nix_get_version_from_commit "$commit" "$path")
    if [[ "$found_version" == "$version" ]]; then
      ish_utils_tui_info --message="$commit"
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

  ish_utils_tui_template "${ISH_TUI_INFO}" "$template" package "$package" version "$version" commit "$commit"
}
