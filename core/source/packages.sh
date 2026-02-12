#!/usr/bin/env bash

# Package discovery and routing
# Convention: packages/ish-{name}/ with source/{name}.sh router

ish_packages_discover() {
  local pkg_dir pkg_name pkg_router

  for pkg_dir in "${ISH_PACKAGES}"/ish-*; do
    [[ -d "${pkg_dir}" ]] || continue

    # Extract name: ish-ratfiles → ratfiles
    pkg_name="${pkg_dir##*/ish-}"

    # Source router by convention
    pkg_router="${pkg_dir}/source/${pkg_name}.sh"
    [[ -f "${pkg_router}" ]] && source "${pkg_router}"
  done
}

ish_packages_route() {
  local cmd="${1-}"
  shift || true

  # Try to route to package
  local route_fn="ish_${cmd}_route"
  if declare -F "${route_fn}" >/dev/null 2>&1; then
    "${route_fn}" "$@"
    return $?
  fi

  return 1
}
