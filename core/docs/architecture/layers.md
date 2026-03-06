# layers

the architecture is a stack. each layer depends only on the layer below it.

```
package code        uses semantic wrappers (reads like English)
    ↓
semantic layer      hides FP machinery behind clear names
    ↓
extensions        compose primitives around external binaries
    ↓
primitives          FP operations on data flow
    ↓
foundation          environment introspection (the bottom)
```

## foundation

"what can this environment do?"

| module | file | what it answers |
|--------|------|----------------|
| color | `core/source/color.sh` | can this terminal render colors? |
| file_descriptor | `core/source/file_descriptor.sh` | can I do POSIX I/O on this fd? |
| exists | `core/source/exists.sh` | is this command available? (`type` builtin) |

no dependencies. everything above stands on these three.

## primitives

"how do I move data?"

| module | file | what it does |
|--------|------|-------------|
| stream | `core/source/stream.sh` | map, bind, filter, fold over stdin/stdout |
| result | `core/source/result.sh` | and_then, or_else, map for single command outcomes |
| file | `core/source/file.sh` | read, write, exists for persistent storage |
| pipe | `core/source/pipe.sh` | process composition, PIPESTATUS, error chaining |

built on file_descriptor. stream iterates sequences (N lines). result chains single operations. the contrast between `ish_result_and_then` (tight coupling) and bare sequential calls (loose coupling) is itself documentation of design intent.

## extensions

"how do I use this external tool?"

| module | file | wraps |
|--------|------|-------|
| sqlite | `extensions/source/sqlite.sh` | sqlite3 |
| git | `extensions/source/git.sh` | git |
| curl | `extensions/source/curl.sh` | curl |
| ssh | `extensions/source/ssh.sh` | ssh |
| jq | `extensions/source/jq.sh` | jq |

every integration calls `ish_exists_executable` before invoking its binary.
composed through primitives (stream + file + pipe).

### why extensions must use primitives

external binaries are unpredictable. `sqlite3`, `git`, `curl` — each has its own error format, output conventions, and behavioral quirks. a new release can change exit codes, reformat stderr, or alter default delimiters. ish has no control over these decisions.

the primitives provide a consistent monadic contract: `ish_stream_stderr` for error output, `ish_stream_filter` for line filtering, `ish_stream_fold` for accumulation. when an integration uses these instead of raw `printf`, `grep`, or shell arithmetic, it inherits:

- **uniform error propagation** — every error flows through the same mechanism
- **composability** — output from one integration feeds into any primitive
- **insulation** — if a CLI changes behavior, the fix is in one integration, not scattered across raw shell calls

the rule: if an ish primitive exists for the operation, the integration uses it. raw shell is for the `sqlite3`/`git`/`curl` invocation itself — the boundary crossing. everything before and after that crossing flows through primitives.

## semantic layer

translation from FP machinery to English-like names.

```bash
# instead of
ish_stream_bind _validate_foo "$input" || return $?

# package code writes
require_valid_foo "$input"
```

## naming convention

function names map to file paths. left-to-right scope narrowing:

```
ish_stream_map      → core/source/stream.sh
ish_file_exists     → core/source/file.sh
ish_sqlite_query    → extensions/source/sqlite.sh
ish_tui_error       → core/source/tui.sh
```

if you know the function name, you know where to find it.

## see also

- [monads.md](monads.md) — how bind works at every layer
- [primitives.md](primitives.md) — type signatures and examples
- [fp_vision.md](../vision/fp_vision.md) — where this goes
