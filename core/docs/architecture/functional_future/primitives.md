# primitives

type signatures and behavior for each FP module.

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

# @type: --fd=int -> [string]
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
# @type: (a -> b) -> [a] -> [b]
printf '%s\n' "foo" "bar" | ish_stream_map to_upper

# @type: (a -> M b) -> M a -> M b
# short-circuits on failure (|| return $?)
printf '%s\n' "foo" "bar" | ish_stream_bind validate_item

# @type: (a -> bool) -> [a] -> [a]
printf '%s\n' "foo" "bar" "baz" | ish_stream_filter is_valid

# @type: (b -> a -> b) -> b -> [a] -> b
printf '%s\n' "1" "2" "3" | ish_stream_fold sum_fn 0

# @type: string -> IO ()
ish_stream_stdout "foo"
ish_stream_stderr "bar"
```

### file (planned)

```bash
# @type: --path=string -> string
ish_file_read --path=/tmp/foo.txt

# @type: --path=string -> stdin -> IO ()
echo "bar" | ish_file_write --path=/tmp/foo.txt

# @type: --path=string -> bool
ish_file_exists --path=/tmp/foo.txt
```

### pipe (planned)

```bash
# @type: [cmd] -> IO () | error (with PIPESTATUS awareness)
ish_pipe_compose cmd_a cmd_b cmd_c
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

- [layers.md](layers.md) — where each module sits in the stack
- [monads.md](monads.md) — how bind works
