# build ish_ssh - functional remote execution

**dependencies:** build-fp-core-stream, build-fp-core-file, build-fp-core-pipe

**priority:** normal (phase 5 — no consumer until remote execution)

## description

Build functional SSH integration that composes core stream and file primitives around shell calls to `ssh` and `scp`. Not a bash primitive — this is a composition layer over external binaries. Remote command output flows through stream, file transfers flow through file.

Callers own the commands and host targeting (what to run where). This module owns the execution (how to connect and run it).

## subtasks

- [ ] implement `ish_ssh_exec` - execute command on remote host, stream stdout
- [ ] implement `ish_ssh_copy_to` - copy local file to remote host
- [ ] implement `ish_ssh_copy_from` - copy remote file to local host
- [ ] implement `ish_ssh_bind` - chain remote operations with error propagation
- [ ] implement `ish_ssh_require` - assert ssh exists or fail with message
- [ ] implement `ish_ssh_is_reachable` - predicate: can we connect to host?
- [ ] write unit tests for each primitive
- [ ] test monad laws (identity, composition) for ssh_bind
- [ ] document with type signatures and examples

## deliverable

`core/source/ssh.sh` with tested FP primitives

## notes

**Concrete patterns from the vision to extract:**
- remote command execution: run a command on a host, capture output
- file deployment: copy configs/scripts to remote hosts
- connectivity checks: is the host reachable before attempting operations?
- fleet operations: same command across multiple hosts (built on top of this primitive)

**Type signatures:**
```bash
# @type: host -> command -> IO string | error
ish_ssh_exec()

# @type: local_path -> host -> remote_path -> IO () | error
ish_ssh_copy_to()

# @type: host -> remote_path -> local_path -> IO () | error
ish_ssh_copy_from()

# @type: (IO a) -> (IO b) -> IO b | error
ish_ssh_bind()

# @type: IO () | error
ish_ssh_require()

# @type: host -> bool
ish_ssh_is_reachable()
```

**Host format.** accept `user@host` or just `host` (uses current user). port via `--port=` flag. SSH config (`~/.ssh/config`) handles aliases and key selection — this module doesn't reinvent that.

**The canonical remote chain:**
```bash
# imperative
ish_ssh_is_reachable "$host" \
    && ish_ssh_copy_to "deploy.sh" "$host" "/tmp/deploy.sh" \
    && ish_ssh_exec "$host" "bash /tmp/deploy.sh"

# monadic
ish_ssh_bind \
    "ish_ssh_copy_to deploy.sh $host /tmp/deploy.sh" \
    "ish_ssh_exec $host 'bash /tmp/deploy.sh'"
```

**Error context is critical.** a bare "connection refused" is useless. each function must include which host, what operation, and what the user should do about it. example: `"ssh exec failed on web01 — connection refused. check host is up and ssh key is authorized"`.

**Stderr handling.** remote commands produce both stdout and stderr. stdout is the data stream (captured by stream primitives). stderr is diagnostic output. this module must not mix them — remote stderr should flow to local stderr, remote stdout to local stdout.

**Failure modes (all must produce actionable error messages):**
- Connection refused (host down, wrong port)
- Authentication failure (wrong key, not authorized)
- Connection timeout (network issue, firewall)
- Remote command failure (non-zero exit from remote command)
- File transfer failure (permission denied, disk full, path not found)
- Host key verification failure (first connection, changed key)

**Performance characteristics:**
- Connection setup: ~100-500ms (TCP + SSH handshake + auth)
- Command execution: depends on remote command
- File transfer: depends on file size and network
- Connection multiplexing: SSH ControlMaster can amortize setup cost across multiple operations to same host
- Acceptable for: host-by-host operations at human scale

**Testing:**
- [ ] Unit tests for each operation (use localhost as test target)
- [ ] Test error propagation through bind chains
- [ ] Test failure modes: connection refused, auth failure, remote command failure
- [ ] Test file transfer in both directions
- [ ] Test is_reachable predicate
