# primitives

type signatures and behavior for each FP module. signatures use `string` — bash's only type. see [types.md](types.md) for why.

## foundation

### color

```bash
ish_color_init()
# sets ISH_COLOR_RED, ISH_COLOR_GREEN, ISH_COLOR_YELLOW, ISH_COLOR_CLEAR
# empty strings when not a terminal, NO_COLOR set, or TERM=dumb
```

### file_descriptor

```bash
# @type: --path=string --fd=int --mode=(read|write|append) -> IO ()
ish_file_descriptor_open --path=/tmp/foo.txt --fd=5 --mode=read

# @type: --fd=int -> stdout
ish_file_descriptor_read --fd=5

# @type: --fd=int -> stdin -> IO ()
echo "bar" | ish_file_descriptor_write --fd=5

# @type: --fd=int -> IO ()
ish_file_descriptor_close --fd=5

# @type: --source=int --target=int -> IO ()
ish_file_descriptor_duplicate --source=5 --target=6

# @type: --fd=int -> IO () | error
ish_file_descriptor_require --fd=5
```

### exists

```bash
# @type: --executable=string -> bool
# wraps shell `type` builtin (checks builtins, functions, aliases, PATH)
ish_exists_executable --executable=foo_cmd
```

## primitives

### stream

```bash
# @type: (string -> string) -> stdin -> stdout
printf '%s\n' "foo" "bar" | ish_stream_map to_upper

# @type: (string -> result string) -> stdin -> result stdout
# short-circuits on failure (|| return $?)
printf '%s\n' "foo" "bar" | ish_stream_bind validate_item

# @type: (string -> bool) -> stdin -> stdout
printf '%s\n' "foo" "bar" "baz" | ish_stream_filter is_valid

# @type: (string -> string -> string) -> string -> stdin -> string
printf '%s\n' "1" "2" "3" | ish_stream_fold sum_fn 0

# @type: stdin -> stdout
# identity operation — consume stdin, emit to stdout (replaces raw cat)
printf '%s\n' "foo" "bar" | ish_stream_read

# @type: string -> IO ()
ish_stream_stdout "foo"
ish_stream_stderr "bar"
```

### file

```bash
# @type: --path=string -> stdout
ish_file_read --path=/tmp/foo.txt

# @type: --path=string -> stdin -> IO ()
echo "bar" | ish_file_write --path=/tmp/foo.txt

# @type: --path=string -> stdin -> IO ()
echo "more" | ish_file_append --path=/tmp/foo.txt

# @type: --path=string -> bool
ish_file_exists --path=/tmp/foo.txt

# @type: --path=string [--message=string] -> IO () | error
ish_file_require --path=/tmp/foo.txt
```

### result

```bash
# @type: [(() -> IO ())] -> IO () | error
# run each function in sequence, short-circuit on first failure
ish_result_and_then step_a step_b step_c

# @type: (() -> IO ()) -> (() -> IO ()) -> IO ()
# run primary, if failure run fallback
ish_result_or_else load_config use_defaults

# @type: (() -> string) -> (string -> string) -> string | error
# run command, capture stdout safely, transform on success
ish_result_map get_version format_semver
```

### pipe

```bash
# @type: cmd_a -> cmd_b -> IO output | error (captures PIPESTATUS)
ish_pipe_connect cmd_a cmd_b

# @type: [cmd] -> IO output | error (captures PIPESTATUS, 2-5 stages)
ish_pipe_compose cmd_a cmd_b [cmd_c] [cmd_d] [cmd_e]

# @type: stdin -> [destination] -> stdout (pass-through + write to files)
ish_pipe_tee dest1 [dest2] ...

# @type: IO [int] (one exit code per line from last pipeline)
ish_pipe_status

# @type: IO () | error (if any stage non-zero)
ish_pipe_require_success
```

## testing strategy

each primitive tests:
1. **correctness** — does it produce the right output?
2. **monad laws** — left identity, right identity, associativity
3. **error propagation** — does bind short-circuit on failure?

```bash
# monad left identity: bind(return(a), f) = f(a)
@test "stream_bind left identity" {
  result=$(echo "foo" | ish_stream_bind some_fn)
  expected=$(some_fn "foo")
  assert_equal "$result" "$expected"
}
```

## see also

- [types.md](types.md) — what maps from ML to bash and what doesn't
- [layers.md](layers.md) — where each module sits in the stack
- [monads.md](monads.md) — how bind works
