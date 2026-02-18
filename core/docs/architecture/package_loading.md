# package loading

## environment variables

set by entry point, available to all code:

- `ISH_ROOT` — repository root (or `~/.ish` in installed mode)
- `ISH_CORE` — framework source directory (`core/source/`)
- `ISH_PACKAGES` — packages directory (`packages/`)

## loading sequence

### 1. calculate paths

```bash
ISH_ROOT=$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/../.." && pwd -P)
ISH_CORE="${ISH_ROOT}/core/source"
ISH_PACKAGES="${ISH_ROOT}/packages"
export ISH_ROOT ISH_CORE ISH_PACKAGES
```

### 2. load framework core

framework modules load first — they provide foundation for all packages:

```bash
source "${ISH_CORE}/tui.sh"
source "${ISH_CORE}/platform.sh"
```

### 3. discover packages (current: explicit routing)

```bash
case "${1-}" in
  kanban)
    source "${ISH_PACKAGES}/ish-kanban/source/kanban.sh"
    ish_kanban_route "$@"
    ;;
  ratfiles)
    source "${ISH_PACKAGES}/ish-ratfiles/source/ratfiles.sh"
    ish_ratfiles_route "$@"
    ;;
esac
```

### 4. discover packages (future: auto-discovery)

```bash
for pkg_dir in "${ISH_PACKAGES}"/*; do
  [[ -d "${pkg_dir}" ]] || continue
  pkg_name=$(basename "${pkg_dir}")
  pkg_router="${pkg_dir}/source/${pkg_name}.sh"
  [[ -f "${pkg_router}" ]] && source "${pkg_router}"
done
```

### 5. dispatch

```bash
if type -t "ish_${cmd}_route" &>/dev/null; then
  "ish_${cmd}_route" "$@"
  exit $?
fi
ish_tui_error --message="unknown command: ${cmd}"
```

## PATH management

`ish self install` adds `~/.ish/core/bin` to `$PATH` in the user's shell config file. packages can also provide binaries in their `bin/` directory.
