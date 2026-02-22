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

## subtasks

- [ ] for each atom: document bash representation, ish examples, and whether anything needs building
- [ ] identify where implicit types caused architectural confusion (file_bind is one — what else?)
- [ ] assess: do any atoms need explicit utility functions, or are bash idioms sufficient?
- [ ] write architecture doc: `core/docs/architecture/types.md`
- [ ] review: does the atom mapping change how we think about any existing or planned modules?

## deliverable

`core/docs/architecture/types.md` — the translation table from meta language atoms to bash, grounded in ish examples. Not theory — a practical mapping that prevents the next file_bind.

## notes

This is exploratory. The goal is understanding, not code. If the mapping reveals that bash idioms are sufficient (likely for unit, void, function, sum), document that and move on. If it reveals a gap (possibly product), assess whether a utility earns its keep or whether `awk -F'|'` is fine.

The litmus test for building something new: are we writing the same destructuring/construction boilerplate in 2+ places? If yes, extract. If no, the idiom is fine.
