# layers

the architecture is a stack. each layer depends only on the layer below it.

```
package code        uses semantic wrappers (reads like English)
    ↓
semantic layer      hides FP machinery behind clear names
    ↓
integrations        compose primitives around external binaries
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
| file | `core/source/file.sh` | read, write, exists for persistent storage |
| pipe | `core/source/pipe.sh` | process composition, PIPESTATUS, error chaining |

built on file_descriptor. bind (monadic composition) lives in stream — it iterates stdin, which is a stream operation regardless of what the data represents.

## integrations

"how do I use this external tool?"

| module | file | wraps |
|--------|------|-------|
| sqlite | `core/source/sqlite.sh` | sqlite3 |
| git | `core/source/git.sh` | git |
| curl | `core/source/curl.sh` | curl |
| ssh | `core/source/ssh.sh` | ssh |
| jq | `core/source/jq.sh` | jq |

every integration calls `ish_exists_executable` before invoking its binary.
composed through primitives (stream + file + pipe).

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
ish_sqlite_query    → core/source/sqlite.sh
ish_tui_error       → core/source/tui.sh
```

if you know the function name, you know where to find it.

## see also

- [monads.md](monads.md) — how bind works at every layer
- [primitives.md](primitives.md) — type signatures and examples
- [fp_vision.md](../vision/fp_vision.md) — where this goes
