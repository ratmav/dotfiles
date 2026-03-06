#!/usr/bin/env bash

# Extension loading. Sources extension modules when their wrapped binary is present.
# Extension names match their wrapped binary (git wraps git, sqlite3 wraps sqlite3).

ish_extensions_load() {
  local name="$1"

  if ish_exists_executable --executable="$name"; then
    source "${ISH_EXTENSIONS}/source/${name}.sh"
  else
    ish_tui_warn --message="${name} not found — ${name} extension not loaded"
  fi
}
