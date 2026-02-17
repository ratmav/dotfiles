# output patterns

**separate concerns: messages vs data output**

the tui module provides distinct functions for different output purposes:

**message functions** (stderr):
- `ish_tui_error --message="text"` - error messages, exits with code 1
- `ish_tui_warn --message="text"` - warning messages, continues
- `ish_tui_info --message="text"` - info messages, continues

**data output functions** (stdout):
- `ish_stream_stdout "value"` - plain data output via printf
- `ish_tui_template_file --path=file` - outputs file contents to stdout

**why separate?**

1. **composability** - stdout can be piped, redirected, or captured
   ```bash
   content=$(ish tui template file --path=board.md)
   ish tui template file --path=data.json | jq '.items'
   ish tui template file --path=template.conf > /etc/app.conf
   ```

2. **clarity** - explicit function names document intent
   ```bash
   ish_tui_info --message="loading template"          # user message (stderr)
   ish_tui_template_file --path=board.md              # data output (stdout)
   ```

3. **unix philosophy** - errors to stderr, data to stdout
   - messages don't pollute data streams
   - scripts can capture output without filtering error messages

**explicit intent pattern:**

```bash
# return value (captured with command substitution)
foo_bar_action() {
  # ... logic ...
  ish_stream_stdout "result"
}
value=$(foo_bar_action)  # captures "result"

# help text (stderr)
foo_help() {
  ish_stream_stderr "usage: ish foo [command]"
  ish_stream_stderr ""
  ish_stream_stderr "commands:"
  ish_stream_stderr "  bar    do bar things"
}

# user messages (stderr, colored)
ish_tui_info --message="detected value: $value"
ish_tui_warn --message="unexpected state"
ish_tui_error --message="operation failed"

# file/data output (stdout, pipeable)
ish_tui_template_file --path=board.md
```

**why ish_stream_stdout over bare echo?**

1. **safe** - printf handles edge cases (dash-prefixed args, special chars)
   ```bash
   echo "-n"                # outputs nothing (echo treats -n as flag)
   ish_stream_stdout "-n"   # outputs "-n"
   ```

2. **explicit** - replaces ambiguous echo with clear intent

3. **consistent** - complements ish_tui_* message functions

**child modules and the dag:**

child modules use parent's functions without sourcing parent. parent sources dependencies first, then sources child. see [dag.md](dag.md) for details.

## utility abstractions

extract common patterns when they repeat **2+ times**.

**the 2+ rule:**
- 1 occurrence → write inline
- 2+ occurrences → extract to utility function
- abstractions emerge from actual repetition, not speculation

**example:**
```bash
# pattern: checking if command exists (repeated across codebase)
if type foo > /dev/null 2>&1; then

# extracted to:
if ish_exists_executable --executable=foo; then
```

**conventions:**
- follow bash conventions: return 0 for true, non-zero for false
