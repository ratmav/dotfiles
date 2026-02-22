# build ish_curl - functional HTTP operations

**dependencies:** build-fp-core-stream, build-fp-core-file, build-fp-core-pipe

**priority:** normal (phase 5 — no consumer until remote execution)

## description

Build functional HTTP integration that composes core stream and file primitives around shell calls to `curl`. Not a bash primitive — this is a composition layer over an external binary. Response bodies flow through stream, downloaded files flow through file.

Callers own the URLs and semantics (what to request). This module owns the execution (how to run it).

## subtasks

- [ ] implement `ish_curl_get` - GET request, stream response body to stdout
- [ ] implement `ish_curl_post` - POST with data, stream response body to stdout
- [ ] implement `ish_curl_put` - PUT with data, stream response body to stdout
- [ ] implement `ish_curl_delete` - DELETE request, stream response body to stdout
- [ ] implement `ish_curl_head` - HEAD request, stream response headers to stdout
- [ ] implement `ish_curl_bind` - chain HTTP operations with error propagation
- [ ] implement `ish_curl_require` - assert curl exists or fail with message
- [ ] write unit tests for each primitive
- [ ] test monad laws (identity, composition) for curl_bind
- [ ] document with type signatures and examples

## deliverable

`core/source/curl.sh` with tested FP primitives

## notes

**Concrete patterns from the vision to extract:**
- cloud API calls: GET/POST to DigitalOcean, AWS, etc.
- response body piped to `jq` for JSON parsing (see ish_jq)
- authentication via headers (Bearer tokens, API keys)
- status code checking: 2xx = success, 4xx/5xx = failure with context

**Type signatures:**
```bash
# @type: url -> [header] -> IO string | error
ish_curl_get()

# @type: url -> data -> [header] -> IO string | error
ish_curl_post()

# @type: url -> data -> [header] -> IO string | error
ish_curl_put()

# @type: url -> [header] -> IO string | error
ish_curl_delete()

# @type: url -> [header] -> IO string | error
ish_curl_head()

# @type: (IO a) -> (IO b) -> IO b | error
ish_curl_bind()

# @type: IO () | error
ish_curl_require()
```

**HTTP status codes are the error signal.** curl returns 0 on successful transfer regardless of HTTP status. this module must check the HTTP status code (`-w '%{http_code}'`) and fail on 4xx/5xx with the status code and response body in the error message. callers should never have to parse status codes.

**Headers use --header= flag pattern.** consistent with ish CLI conventions. multiple headers are multiple flags:
```bash
ish_curl_get "$url" \
    --header="Authorization: Bearer $token" \
    --header="Content-Type: application/json"
```

**Response body is the output.** headers, status code, and metadata are internal. callers get the body on stdout and errors on stderr. if callers need headers, use `ish_curl_head`.

**Composition with jq:**
```bash
# curl streams body, pipe connects to jq, stream processes lines
ish_curl_get "https://api.example.com/droplets" \
    --header="Authorization: Bearer $token" \
    | jq '.droplets[].name' \
    | ish_stream_map process_droplet
```

**Failure modes (all must produce actionable error messages):**
- DNS resolution failure
- Connection refused / timeout
- TLS/SSL errors
- HTTP 4xx (client error — bad request, auth failure, not found)
- HTTP 5xx (server error — retry? report?)
- Empty response body

**Performance characteristics:**
- Process spawn: ~5ms per curl invocation
- Network latency: dominates everything else
- Connection reuse: not applicable (one curl per call)
- Acceptable for: API calls at human scale (not bulk/batch)

**Testing:**
- [ ] Unit tests for each HTTP method
- [ ] Test error propagation through bind chains
- [ ] Test HTTP status code handling (mock server or fixture responses)
- [ ] Test header passing
- [ ] Test failure modes: connection refused, timeout, 404, 500

**See also:** core/docs/architecture/just_use_curl.md
