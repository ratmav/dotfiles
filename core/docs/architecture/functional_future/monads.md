# monads in ish

## the short version

`&&` is already bind. Every `*_bind` function in the architecture formalizes what `&&` does informally — chain operations that can fail, stop on the first failure, carry error context forward.

```bash
# this is monadic (just syntax)
ish_git_add "foo.sql" \
    && ish_git_commit "update foo" \
    && ish_git_push

# this is the same thing, formalized
ish_git_bind \
    "ish_git_add foo.sql" \
    "ish_git_commit 'update foo'" \
    "ish_git_push"
```

the difference: `&&` is fire-and-forget. `bind` adds error context (which step failed, what to do about it) and makes the chain a composable value rather than syntax.

## where bind lives

every layer has its own bind function. the pattern is identical — chain operations, short-circuit on failure — but the failure modes and error context get richer as you move up the stack.

| layer | bind function | what it chains | failure modes |
|-------|--------------|----------------|---------------|
| foundation | `ish_color_init` | terminal capability detection | non-terminal, NO_COLOR, dumb term |
| foundation | `ish_file_descriptor_bind` | fd operations | open/close/redirect failures |
| foundation | `ish_exists_executable` | command availability (`type` builtin) | missing binary, no PATH entry |
| primitive | `ish_stream_bind` | line transforms | bad data, transform errors |
| primitive | `ish_file_bind` | file operations | missing files, permission, disk full |
| primitive | `ish_pipe_bind` | pipeline stages | any stage failure (via PIPESTATUS) |
| integration | `ish_sqlite_bind` | queries | constraint violations, corrupt db |
| integration | `ish_git_bind` | git operations | conflicts, auth, network timeout |

the foundation answers three questions every layer above needs answered:
- **color:** "can this terminal render colors?" (capability)
- **file_descriptor:** "can I do POSIX I/O on this fd?" (I/O)
- **exists:** "is this command available?" (environment)

`ish_exists_executable` wraps the shell `type` builtin — it checks builtins, functions, aliases, and PATH. it's environment introspection, not file I/O (`[[ -f ]]` checks files; `type` checks the shell's command resolution). every integration must call `ish_exists_executable` before invoking its external binary (sqlite3, git, curl, ssh, jq, awk, etc.).

the primitives give you building blocks. the integrations compose them into real workflows.

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

`|| return $?` is the entire monad. if `$func` returns non-zero, bind stops immediately and propagates the exit code. no remaining lines are processed. the caller sees the failure and can either handle it or propagate it further.

this is proven by test:

```bash
# "good" → ok:good (succeed, continue)
# "bad"  → return 1 (fail, stop)
# "good" → never reached
printf '%s\n' "good" "bad" "good" | ish_stream_bind _fail_on_bad
# output: "ok:good"
# status: 1
```

## monad laws

the bind functions must satisfy three laws for composition to work correctly:

**left identity:** `bind(return(a), f) = f(a)` — wrapping a value and immediately binding should equal calling f directly.

**right identity:** `bind(m, return) = m` — binding with identity produces the original value.

**associativity:** `bind(bind(m, f), g) = bind(m, λx.bind(f(x), g))` — grouping doesn't matter.

in bash terms: chaining three operations with bind must produce the same result regardless of how you parenthesize them. the task specs call out testing these laws explicitly.

## where monads earn their keep

at the primitive layer, bind is useful but small — it short-circuits on bad stdin lines. functional, but not dramatic.

at the integration layer, bind becomes architecturally significant. the canonical example is the git write path:

```bash
ish_git_bind \
    "ish_git_add foo.sql" \
    "ish_git_commit 'update foo'" \
    "ish_git_push"
```

each step depends on the prior succeeding. each has rich failure modes:
- `git add` — file doesn't exist, not in a repo
- `git commit` — nothing staged, hook failure
- `git push` — no remote, auth failure, conflicts, network timeout

a bare `&&` chain can't carry this context. bind formalizes the chain so each step knows what failed, where, and what the user should do about it.

the same pattern applies to sqlite transactions — a failed INSERT inside a transaction needs to ROLLBACK and report which constraint was violated, not just "something failed."

## relationship to the stack

```
package code         uses semantic wrappers (reads like English)
    ↓
semantic layer       calls bind chains (hides FP machinery)
    ↓
integration binds    compose primitive operations (git, sqlite)
    ↓
primitive binds      chain POSIX operations (stream, file, pipe)
    ↓
foundation           color, file_descriptor, exists (the bottom)
```

monads are the vertical spine. every layer's bind composes the layer below it. package code never sees bind directly — the semantic layer hides it behind names like `require_valid_foo` and `fail_with`.

## see also

- `core/source/stream.sh` — working bind implementation
- `core/test/unit/stream.bats` — bind tests including short-circuit proof
- [layers.md](layers.md) — the full stack
- [primitives.md](primitives.md) — type signatures and examples
