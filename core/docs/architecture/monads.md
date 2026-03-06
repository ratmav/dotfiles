# bind in ish

## the short version

`stream_bind` iterates over dynamic data from stdin and short-circuits on the first failure. it exists because you don't know the data at write time — it flows through pipes.

for known step sequences (git add → commit → push), use `ish_result_and_then`. it names the `&&` pattern, making tight coupling explicit. error context belongs in each function, not in a wrapper.

## where bind lives

bind exists at the **primitive** layer only. it operates on dynamic stdin data — lines you can't enumerate at write time.

| layer | function | what it does |
|-------|----------|-------------|
| primitive | `ish_stream_bind` | apply function to each stdin line, stop on failure |
| primitive | `ish_result_and_then` | run functions in sequence, stop on first failure |
| primitive | `ish_result_or_else` | run primary, fall back on failure |
| primitive | `ish_result_map` | run command, transform output on success |

stream_bind iterates dynamic data (N lines). result combinators chain single operations (known steps). extensions (git, sqlite) use result combinators for their step sequences:

```bash
_add()    { ish_git_add "kanban.sql"; }
_commit() { ish_git_commit "update kanban data"; }

ish_result_and_then _add _commit ish_git_push
```

each function provides its own error context. `ish_result_and_then` handles the short-circuiting and names the intent: "these steps are a unit."

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

**use `ish_result_and_then`** when chaining known operations:

```bash
# each function handles its own errors
_add()    { ish_git_add "foo.sql"; }
_commit() { ish_git_commit "update foo"; }

ish_result_and_then _add _commit ish_git_push
```

**use bare sequential calls** when steps are independent and partial success is acceptable:

```bash
# loose coupling — if apt fails, rust install still runs
ish_ratfiles_bootstrap_kali_apt
ish_ratfiles_bootstrap_kali_rust
ish_ratfiles_bootstrap_kali_wezterm
```

the distinction: bind iterates over data. result_and_then sequences commands tightly. bare calls sequence loosely. the contrast between these three is itself documentation of intent.

## composition laws

the bind functions satisfy three laws that ensure composition works correctly:

**left identity:** `echo "a" | bind f` equals `f "a"` — feeding a single value through bind equals calling f directly.

**right identity:** `echo "a" | bind echo` equals `echo "a"` — binding with identity is a no-op.

**associativity:** `data | bind f | bind g` equals `data | bind (f | bind g)` — grouping doesn't matter.

these are verified by unit tests for `stream_bind`.

## see also

- `core/source/stream.sh` — stream_bind implementation
- `core/source/result.sh` — result combinator implementations
- `core/test/unit/stream.bats` — bind tests including short-circuit proof and monad laws
- `core/test/unit/result.bats` — result combinator tests
- [layers.md](layers.md) — the full stack
- [primitives.md](primitives.md) — type signatures and examples
