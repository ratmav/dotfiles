# 002: ssh key management features

**milestone:** 1 - complete current architecture

**dependencies:** none

## description

develop new feature with abilitly to start the ssh agent if it's not already running, list available keys (only keys, ignore common files like known_keys, config, etc.), pick a key, and add it to the agent

see https://github.com/ratmav/docs/blob/master/ssh.md#configure-local-ssh-agent for details.

## subtasks

- [ ] implement ssh agent status check
- [ ] start ssh agent if not running
- [ ] list available ssh keys (filter out known_hosts, config, etc.)
- [ ] implement key selection interface
- [ ] add selected key to agent
- [ ] create `ish ssh key enable` command

## deliverable

`ish ssh key enable` command

## notes

current code is battle-tested. don't restructure - add features using existing patterns.
