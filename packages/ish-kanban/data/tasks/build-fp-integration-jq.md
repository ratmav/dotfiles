# build ish_jq - functional JSON operations

**dependencies:** build-fp-core-stream, build-fp-core-pipe

**priority:** normal (phase 5 — no consumer until remote execution)

## description

Build functional JSON integration that composes core stream primitives around shell calls to `jq`. Not a bash primitive — this is a composition layer over an external binary. JSON input flows in via stdin, transformed output flows through stream.

Companion to `ish_curl`. curl handles HTTP transport, jq handles JSON parsing. Together they cover the API integration pattern: request → parse → act.

## subtasks

- [ ] implement `ish_jq_query` - run jq expression on stdin, stream results to stdout
- [ ] implement `ish_jq_extract` - extract single value from JSON input or fail
- [ ] implement `ish_jq_bind` - chain JSON operations with error propagation
- [ ] implement `ish_jq_require` - assert jq exists or fail with message
- [ ] write unit tests for each primitive
- [ ] test monad laws (identity, composition) for jq_bind
- [ ] document with type signatures and examples

## deliverable

`core/source/jq.sh` with tested FP primitives

## notes

**Concrete patterns from the vision to extract:**
- API response parsing: extract fields from JSON responses
- data transformation: reshape JSON for downstream processing
- single-value extraction: get one field or fail (like sqlite query_one)
- pipeline integration: curl output piped to jq piped to stream operations

**Type signatures:**
```bash
# @type: expression -> stdin (json) -> IO string | error
ish_jq_query()

# @type: expression -> stdin (json) -> IO string | error (if missing/null)
ish_jq_extract()

# @type: (IO a) -> (IO b) -> IO b | error
ish_jq_bind()

# @type: IO () | error
ish_jq_require()
```

**The canonical composition:**
```bash
# curl fetches, jq parses, stream processes
ish_curl_get "$api_url/droplets" \
    --header="Authorization: Bearer $token" \
    | ish_jq_query '.droplets[] | {name, ip: .networks.v4[0].ip_address}' \
    | ish_stream_map register_host

# extract single value or fail
token=$(ish_curl_post "$api_url/auth" --data="$creds" \
    | ish_jq_extract '.access_token')
```

**query vs extract.** `query` streams zero or more results (like sqlite_query). `extract` returns exactly one value or fails (like sqlite_query_one). this distinction matters — callers must know if they're processing a collection or expecting a scalar.

**Raw output by default.** `ish_jq_query` passes `-r` (raw output) so strings come without quotes. JSON arrays/objects remain as JSON. this matches how callers typically use jq — they want the values, not the JSON syntax.

**Failure modes (all must produce actionable error messages):**
- Invalid JSON input (malformed response from curl)
- Expression error (bad jq syntax)
- Null/missing value (key doesn't exist in input)
- Type mismatch (expected string, got array)
- Empty input (no data on stdin)

**Performance characteristics:**
- Process spawn: ~5ms per jq invocation
- JSON parsing: near-instant for API-scale responses (< 1MB)
- Streaming: jq handles line-delimited JSON natively
- Acceptable for: API response processing

**Testing:**
- [ ] Unit tests for query and extract (use heredoc JSON fixtures)
- [ ] Test error propagation through bind chains
- [ ] Test with invalid JSON input
- [ ] Test extract fails on missing/null values
- [ ] Test raw output mode (strings without quotes)
