# cli options

## options pattern

commands support `--flag=value` style options for clarity and extensibility.

**format:**
- equals-separated: `--message="text"` (required format)
- no space-separated: `--message "text"` (not supported)
- explicit `--` prefix for readability

**examples:**
```bash
ish tui info --message="build complete"
ish utils exists --executable=bash
ish utils exists --file=/etc/hosts
```

## implementation pattern

for single required option (most common case), use a private parsing helper:

```bash
# public function
foo_bar_action() {
  local path=$(_foo_parse_single_option "--path" "$@")
  [[ -f "$path" ]]
}

# private helper (at bottom of file)
_foo_parse_single_option() {
  local option_name=$1
  shift
  local value=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      "$option_name"=*)
        value="${1#*=}"
        shift
        ;;
      *)
        ish_tui_error --message="unknown option: $1"
        ;;
    esac
  done

  [[ -z "$value" ]] && ish_tui_error --message="$option_name required"

  echo "$value"
}
```

## special case: tui module

tui functions parse options inline and use ish_stream_stderr directly (tui sources stream.sh):

```bash
ish_tui_info() {
  local message=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --message=*)
        message="${1#*=}"
        shift
        ;;
      *)
        ish_stream_stderr "${ISH_TUI_ERROR}unknown option: $1"
        exit 1
        ;;
    esac
  done

  if [[ -z "$message" ]]; then
    ish_stream_stderr "${ISH_TUI_ERROR}--message= required${ISH_TUI_CLEAR}"
    return 1
  fi

  ish_stream_stderr "${ISH_TUI_INFO}${message}${ISH_TUI_CLEAR}"
}
```

**guidelines:**
- inline option parsing when functions can't call ish_tui_error (circular dependency)
- use ish_stream_stderr directly for error messages within tui module
- use ish_tui_error for validation errors in all other modules
