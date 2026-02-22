# define-type-atoms

**dependencies:** none

**priority:** immediate — design spike before further phase 1 work

## description

Define the translation from meta language type atoms (product, sum, function, unit, void) to bash. Every type system has these five building blocks. Bash has them too — they're just implicit. Making them explicit gives us vocabulary for organizing modules by **structure** instead of by **semantics**, which is how we caught the file_bind duplication.

This is a design/spike task. The deliverable is an architecture doc, not code. Code follows only if the mapping reveals missing utilities worth building.

## the five atoms

For each atom, define:
- What it is (one sentence)
- How bash spells it (the concrete syntax/idiom)
- Where ish already uses it (existing code examples)
- Whether ish needs anything new for it (probably not — bash idioms may be sufficient)

### unit

"Exactly one value. Done. Success."

- Bash: exit code 0, `return 0`, successful side effect with no output
- Ish examples: `ish_file_write` on success, `ish_color_init`, `ish_tui_set_colors`
- Question: is there anything to build? or is `return 0` sufficient?

### void

"No values. Unreachable. The function never returns."

- Bash: `exit 1`, functions that always exit (`_file_error`, `ish_tui_error`)
- Ish examples: every `_*_error` private function, `ish_tui_error --message=`
- Question: is this already well-defined enough? the pattern is consistent across modules.

### function

"Given A, produce B."

- Bash: bash functions, `--flag=value` named parameters, higher-order functions (passing function names as arguments)
- Ish examples: `ish_file_read --path=X`, `ish_stream_map some_fn`, `ish_stream_bind validate`
- Question: is the `--flag=value` convention the right "product → B" spelling? are positional args ever appropriate?

### sum

"A or B, not both."

- Bash: exit codes (0 | non-zero), `case` statements, `&&` / `||`
- Ish examples: `ish_file_exists` (bool), routing functions (`case "${1-}" in ...`), `cmd && handle_success || handle_failure`
- Question: does ish need richer sums? exit codes are binary (ok/fail). Should errors carry structured data (error code + message + recovery hint)?

### product

"A and B together."

- Bash: multiple `--flag=value` args, pipe-separated fields, multiple env vars, multiple lines of stdout
- Ish examples: `--path=X --fd=5 --mode=read` (named product), sqlite rows `name|status|priority` (positional product), `ISH_ROOT` + `ISH_CORE` + `ISH_PACKAGES` (global product)
- Question: this is where bash is weakest. no tuples, no structs. does ish need a product destructuring utility? or is `awk -F'|'` and `IFS='|' read` sufficient?

## deliverable

`core/docs/architecture/types.md` — documents what from ML maps to bash (computation model) and what doesn't (type system).

also updated: `core/docs/architecture/primitives.md` — type signatures now use `string` instead of polymorphic `a`.

## findings

the investigation revealed a sharper insight than the original hypothesis. ML has two orthogonal systems: a **type system** (static, what data IS) and a **computation model** (dynamic, how data flows). bash imports the computation model but not the type system. everything is a string.

- **computation patterns map:** monadic bind, result combinators (`&&`, `||`), map/filter/fold, higher-order functions. enforced by bash's runtime (pipes, short-circuit, channel separation).
- **type atoms don't map:** product, sum, unit, void are descriptive labels with no enforcement. naming `--flag=value` a "product type" is mathematically accurate but operationally empty.
- **file_bind was caught by computation, not types.** the monad structure revealed the duplication. type vocabulary wouldn't have caught it.
- **nothing needs building.** bash idioms are sufficient. the value is understanding the boundary, not new utilities.
- **result is a computation pattern.** `&&` is `and_then`, `||` is `or_else`, `|| return $?` is monadic bind over the result. enforced by shell mechanisms and channel separation.
