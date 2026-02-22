# bind in ish

## the short version

`stream_bind` iterates over dynamic data from stdin and short-circuits on the first failure. it exists because you don't know the data at write time — it flows through pipes.

for known step sequences (git add → commit → push), use `&&`. it already short-circuits. error context belongs in each function, not in a wrapper.

## where bind lives

bind exists at the **primitive** layer only. it operates on dynamic stdin data — lines you can't enumerate at write time.

| layer | function | what it does |
|-------|----------|-------------|
| primitive | `ish_stream_bind` | apply function to each stdin line, stop on failure |

integrations (git, sqlite) do **not** have bind functions. their operations are known step sequences composed with `&&`:

```bash
ish_git_add "kanban.sql" \
    && ish_git_commit "update kanban data" \
    && ish_git_push
```

each function provides its own error context — what failed, where, what to do. `&&` handles the short-circuiting. no wrapper needed.

## the mechanism

```bash
ish_stream_bind() {
  local func="${1-}"

  [[ -z "$func" ]] && _stream_error "--func required as first argument"

  local line
  while IFS= read -r line; do
    "$func" "$line" || return $?
  done
}
```

`|| return $?` is the key. if `$func` returns non-zero, bind stops immediately and propagates the exit code. no remaining lines are processed.

this is proven by test:

```bash
# "good" → ok:good (succeed, continue)
# "bad"  → return 1 (fail, stop)
# "good" → never reached
printf '%s\n' "good" "bad" "good" | ish_stream_bind _fail_on_bad
# output: "ok:good"
# status: 1
```

## when to use bind vs `&&`

**use bind** when processing dynamic data from stdin — lines you iterate over:

```bash
# validate each item from a stream
printf '%s\n' "a" "b" "c" | ish_stream_bind validate_item

# process each file path from a list
find_migration_files | ish_stream_bind apply_migration
```

**use `&&`** when chaining known operations:

```bash
# each function handles its own errors
ish_git_add "foo.sql" \
    && ish_git_commit "update foo" \
    && ish_git_push
```

the distinction: bind iterates over data. `&&` sequences commands.

## composition laws

the bind functions satisfy three laws that ensure composition works correctly:

**left identity:** `echo "a" | bind f` equals `f "a"` — feeding a single value through bind equals calling f directly.

**right identity:** `echo "a" | bind echo` equals `echo "a"` — binding with identity is a no-op.

**associativity:** `data | bind f | bind g` equals `data | bind (f | bind g)` — grouping doesn't matter.

these are verified by unit tests for `stream_bind`.

## see also

- `core/source/stream.sh` — stream_bind implementation
- `core/test/unit/stream.bats` — bind tests including short-circuit proof and monad laws
- [layers.md](layers.md) — the full stack
- [primitives.md](primitives.md) — type signatures and examples
