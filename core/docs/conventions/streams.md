# stream separation: stdout vs stderr

**the insight: in bash, terminal UI IS stream management.**

both terminal ui and stream separation are about routing text to file descriptors. they're not separate concerns - terminal ui is implemented as stream management.

## the unix philosophy

**stdout (fd 1)**: data - the actual output/return value of a function
**stderr (fd 2)**: diagnostics - messages, warnings, errors, status updates

> standard error is another output stream typically used by programs to output error messages or diagnostics. it is a stream independent of standard output and can be redirected separately.

**our interpretation:** we treat all informational messages as diagnostics (stderr), not just errors. this keeps data streams clean when piping or capturing output.

## the architecture

**foundation layer: `core/source/stream.sh`**
```bash
ish_stream_stdout()  # printf '%s\n' "$*" >&1
ish_stream_stderr()  # printf '%s\n' "$*" >&2
```

- safe output via printf (handles `-n` flags, special chars, newlines)
- no dependencies - this is the base layer
- used by everything else

**terminal ui layer: `core/source/tui.sh`**
```bash
ish_tui_error()  # colored error message, exits with code 1
ish_tui_warn()   # colored warning message, continues execution
ish_tui_info()   # colored info message, continues execution
```

- decorated output with colors and formatting
- all output to stderr (diagnostics)
- depends on stream layer

## usage patterns

**internal functions return data via stdout:**
```bash
foo_bar_value() {
  ish_stream_stdout "result"  # fd 1
}

value=$(foo_bar_value)  # value="result", no pollution
```

**cli routing outputs messages via stderr:**
```bash
foo_route() {
  case "${1-}" in
    *)
      ish_tui_error --message="unknown command: ${1-}"  # fd 2, exits
      ;;
  esac
}
```

**benefits:**
- data is clean when piped or captured
- errors never pollute stdout
- composable: `foo_bar_value | grep pattern` works correctly
- testable: can test stdout and stderr separately

## when to use each

**use `ish_stream_stdout` when:**
- function returns data meant to be captured
- outputting template/file contents
- returning computed values

**use `ish_tui_error` when:**
- invalid input or missing required parameters
- operation failed and cannot continue
- automatically exits with code 1

**use `ish_tui_warn` when:**
- operation succeeded but with caveats
- non-fatal issues detected

**use `ish_tui_info` when:**
- reporting progress or status
- confirming successful operations
- help text and usage messages

**use bare `echo` only when:**
- single-line internal piping: `echo "$var" | command`
- interactive prompts: `echo -n "prompt" >&2`
- never for multi-line output or user-facing messages
