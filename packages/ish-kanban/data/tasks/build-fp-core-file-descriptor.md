# build ish_core_file_descriptor - functional file descriptor operations

**dependencies:** none (this is the foundation)

**priority:** high

## description

Build functional file descriptor primitives — the base layer everything else stands on. File descriptors are the POSIX I/O primitive: an integer referencing an I/O channel. Streams, files, and pipes are all file descriptors underneath.

This module owns the raw fd operations that stream, file, and pipe build on top of.

## subtasks

- [ ] implement `ish_core_file_descriptor_open` - open fd to a target (file, device), return fd number
- [ ] implement `ish_core_file_descriptor_close` - close an fd
- [ ] implement `ish_core_file_descriptor_duplicate` - copy fd to another number (the mechanism behind redirection)
- [ ] implement `ish_core_file_descriptor_read` - read from an fd to stdout
- [ ] implement `ish_core_file_descriptor_write` - write stdin to an fd
- [ ] implement `ish_core_file_descriptor_bind` - chain fd operations with error propagation
- [ ] implement `ish_core_file_descriptor_require` - assert fd is open/valid or fail
- [ ] write unit tests for each primitive
- [ ] test monad laws (identity, composition) for file_descriptor_bind
- [ ] document with type signatures and examples

## deliverable

`packages/ish/source/core/file_descriptor.sh` with tested FP primitives

## notes

**This is the foundation layer.** stream, file, and pipe all build on file descriptors. without this, each of those modules independently reimplements fd handling.

**Type signatures:**
```bash
# @type: filepath -> mode -> IO fd | error
ish_core_file_descriptor_open()

# @type: fd -> IO () | error
ish_core_file_descriptor_close()

# @type: fd_source -> fd_target -> IO () | error
ish_core_file_descriptor_duplicate()

# @type: fd -> IO string | error
ish_core_file_descriptor_read()

# @type: fd -> stdin -> IO () | error
ish_core_file_descriptor_write()

# @type: (fd -> IO b) -> IO fd -> IO b | error
ish_core_file_descriptor_bind()

# @type: fd -> IO () | error
ish_core_file_descriptor_require()
```

**Bash fd mechanics:**
- `exec 3>file` — open fd 3 for writing to file
- `exec 3<file` — open fd 3 for reading from file
- `exec 3>&-` — close fd 3
- `exec 3>&1` — duplicate fd 1 onto fd 3
- fds 0, 1, 2 are stdin, stdout, stderr by convention
- fds 3-9 are available for user use in bash

**Why wrap these?** raw fd manipulation in bash is powerful but error-prone. mismanaged fds leak resources, corrupt output, or silently lose data. wrapping them in monadic error handling means:
- every open has a matching close (or fails explicitly)
- duplicate operations validate source and target
- chain operations short-circuit on any fd error

**Performance characteristics:**

fd operations are near-instant — they're kernel calls, not I/O. the cost is in what you read/write through the fd, not in managing the fd itself.

- open/close/duplicate: microseconds
- no process spawn overhead (these are bash builtins via `exec`)
- no practical performance concern at any scale

**Testing:**
- [ ] Unit tests for correctness (open/close/duplicate/read/write)
- [ ] Test error propagation through bind chains
- [ ] Test fd leak detection (open without close)
- [ ] Test invalid fd operations (read from closed fd, duplicate to invalid target)
- [ ] Test standard fds (0, 1, 2) are not accidentally clobbered
