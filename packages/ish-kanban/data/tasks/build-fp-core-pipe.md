# build ish_pipe - functional pipe operations

**dependencies:** build-fp-core-file-descriptor

**priority:** high

## description

Build functional pipe primitives — the composition mechanism of bash. Pipes connect the stdout of one process to the stdin of another. This is how bash programs chain operations.

Pipes are file descriptors underneath (a pair of fds created by `pipe()` syscall), but they serve a distinct purpose: connecting processes.

## subtasks

- [ ] implement `ish_pipe_connect` - pipe stdout of one command to stdin of another
- [ ] implement `ish_pipe_chain` - compose a sequence of commands into a pipeline
- [ ] implement `ish_pipe_tee` - split pipe output to multiple destinations
- [ ] implement `ish_pipe_bind` - chain pipe operations with error propagation
- [ ] implement `ish_pipe_status` - capture exit status of all pipeline stages (PIPESTATUS)
- [ ] implement `ish_pipe_require_success` - assert all pipeline stages succeeded or fail
- [ ] write unit tests for each primitive
- [ ] test monad laws (identity, composition) for pipe_bind
- [ ] document with type signatures and examples

## deliverable

`core/source/pipe.sh` with tested FP primitives

## notes

**Concrete patterns to extract:**
- chaining shell commands with error awareness (not just `|` which swallows errors)
- capturing PIPESTATUS to know which stage failed
- tee-ing output to both stdout and a log/file simultaneously
- building command pipelines dynamically from function arguments

**Type signatures:**
```bash
# @type: cmd_a -> cmd_b -> IO output | error
ish_pipe_connect()

# @type: [cmd] -> IO output | error
ish_pipe_chain()

# @type: cmd -> [destination] -> IO output | error
ish_pipe_tee()

# @type: (IO a) -> (IO b) -> IO b | error
ish_pipe_bind()

# @type: IO [int] (exit codes per stage)
ish_pipe_status()

# @type: IO () | error (if any stage failed)
ish_pipe_require_success()
```

**PIPESTATUS is critical.** bash's `|` only reports the exit code of the last command. `set -o pipefail` reports the first non-zero, but you lose which stage. `PIPESTATUS` array captures every stage. this module must expose that.

**`set -o pipefail` interaction.** ish already uses `set -Eeuo pipefail` in entry points. this module works with that — `pipe_require_success` validates the full PIPESTATUS array for precise error reporting.

**Performance characteristics:**

pipes are kernel-managed buffers. near-instant for small data volumes.

- Pipe buffer: typically 64KB (kernel-managed)
- Process spawn: ~5ms per stage in the pipeline
- Pipeline throughput: dominated by the slowest stage
- Acceptable for: any pipeline ish will build (typically 2-5 stages)
- Large data: kernel handles backpressure automatically via buffer blocking

**Testing:**
- [ ] Unit tests for correctness (connect/chain/tee)
- [ ] Test error propagation through bind chains
- [ ] Test PIPESTATUS capture with failing middle stages
- [ ] Test tee to multiple destinations
- [ ] Test dynamic pipeline construction
