# types

ML has two orthogonal systems: a **type system** (static, what data IS) and a **computation model** (dynamic, how data flows). bash can import the computation model but not the type system, because bash has no static enforcement. everything is a string.

this doc maps the boundary so we know where to invest.

## what maps: computation

patterns where bash's runtime provides the same guarantees as ML's computation model.

| ML concept | bash mechanism | enforcement | ish example |
|---|---|---|---|
| monadic bind | `\|\| return $?` in while loop | short-circuits on failure | `ish_stream_bind` |
| result combinators | `&&`, `\|\|`, `return $?` | shell sequencing, channel separation | `a && b && c` |
| map | function applied per stdin line | pipe mechanism | `ish_stream_map` |
| filter | predicate per stdin line | pipe mechanism | `ish_stream_filter` |
| fold | accumulator over stdin | pipe mechanism | `ish_stream_fold` |
| composition | pipes, `&&` chaining | shell sequencing | `cmd_a \| cmd_b` |
| higher-order functions | function names as strings | runtime dispatch | `ish_stream_bind validate_item` |

data flows through pipes. `&&` short-circuits on failure. `|| return $?` propagates errors. channels (fd 1 / fd 2) separate success values from error messages.

### result as computation

bash functions produce `(exit_code, stdout, stderr)`. this is ML's `Result` — not as a type, but as a computation pattern enforced by shell mechanisms:

- `&&` is `and_then` — continue only on success
- `||` is `or_else` — handle on failure
- `|| return $?` is monadic bind — propagate the error to the caller
- fd 1 (stdout) carries the success value. fd 2 (stderr) carries the error message. the channel separation is enforced by the OS.

```bash
# result chaining: each step short-circuits on failure
ish_git_add "foo.sql" \
    && ish_git_commit "update foo" \
    && ish_git_push

# result bind over dynamic data: same pattern, per line
printf '%s\n' "a" "b" "c" | ish_stream_bind validate_item
```

the one gap: `$(cmd)` captures stdout but silently discards the exit code. the caller must check `$?` separately. subshell capture destructures only the success branch.

### limitations of string dispatch

bash passes function names as strings, not first-class values. no closures (can't capture local state), no anonymous functions, no partial application. higher-order functions work — they're just limited to pre-defined, named operations.

## what doesn't map: types

patterns where the "type" is a description, not an enforcement. the ML type atoms — product, sum, unit, void — exist in bash only as programmer conventions.

| ML concept | bash analog | why it doesn't map |
|---|---|---|
| product types | `--flag=value` args | just function arguments. naming them "products" doesn't change parsing |
| unit | `return 0`, no stdout | overloaded with bool. no enforcement of the distinction |
| void | `exit 1` | just process termination. no type-level reasoning |
| polymorphism | N/A | everything is a string. `a` in type sigs is always `string` |
| type enforcement | N/A | no type checker. conventions enforced only by the programmer |

calling `--flag=value` a "product type" is mathematically accurate but operationally empty. it doesn't prevent bugs the way `stream_bind` prevents incomplete iteration.

## the file_bind lesson

`file_bind` duplicated `stream_bind` — line-for-line identical. the original framing called this a type confusion: "organize by structure, not semantics." but it's actually a computation confusion: the same monadic bind was implemented twice.

the monad structure revealed the duplication. the type atom vocabulary (product, sum, etc.) wouldn't have caught it. the lesson: when two functions have the same computation pattern, they belong in the same module. bind is bind, regardless of what flows through it.

## what this means for ish

- **invest in computation patterns.** stream operations, result chaining, composition, higher-order functions. these have enforcement and prevent real bugs.
- **don't build type enforcement.** bash doesn't have a type checker and doesn't need one. naming patterns is useful for discussion; building enforcement is not.
- **type signatures should be honest.** `a` is always `string` in bash. `[a]` is `stdin`/`stdout`, not a polymorphic list. see [primitives.md](primitives.md).

## see also

- [primitives.md](primitives.md) — type signatures for each module
- [monads.md](monads.md) — bind as the key computation pattern
- [layers.md](layers.md) — the architecture stack
- [streams](../conventions/streams.md) — stdout/stderr channel separation (result's structural foundation)
