# ish philosophy

## vision: a bash utility library with module registry

**ish is underscore.js for bash** - a comprehensive utility library that makes bash scripting productive, with a remote module registry for community extensions.

more than just a task runner or ansible replacement, ish is:
- **a utility library** - terminal ui, platform detection, file operations, etc. (the standard library bash never had)
- **a task runner** - convention-driven cli routing (like make/just)
- **remote execution** - run any command on remote hosts (ansible alternative)
- **module registry** - share and install bash utilities (like npm/rubygems)

**three layers:**
1. **ish-framework** - core utility library (tui, platform, utils, remote, routing)
2. **ish-project** - project-specific tasks (bootstrap, deploy, provision, etc.)
3. **config** - actual configuration files (dotfiles, etc.)

**see [vision.md](vision.md) for the complete strategic overview.**

this separation enables reusable utilities and convention-driven patterns across multiple projects and a community ecosystem of shared modules.

## core principle: live off the land

**cannibalize the host. work with what you have to get what you want.**

ish requires minimal external dependencies:
- bash (on all posix systems)
- ssh (for remote execution)
- standard posix utilities (grep, awk, sed)

**no requirements for:**
- python/ruby/node interpreters
- pre-installed package managers
- external configuration files
- network connectivity (beyond initial setup)

**why this matters:**
- works on fresh systems out of the box
- can bootstrap itself from nothing
- portable across any posix platform
- viable ansible replacement without python dependency
- single file can be copied and executed immediately

**in practice:**
- check if tools exist before installing
- use built-in bash features over external commands
- bootstrap idempotently (safe to run multiple times)
- self-contained

## nix: asdf replacement only

nix replaces asdf for per-project version management. that's it.

**use nix for:**
- per-project development environments via flakes

**don't use nix for:**
- system packages
- gui applications
- system configuration (no nix-darwin)
- user environment (no home-manager)
- dotfiles

**for everything else:** use ish. live off the land. even the nix installer is a bash script.

## design philosophy

### hemingway over melville: brevity and clarity

**use the minimum levels needed for the current set of commands.**

deep nesting for single commands is premature structure:
```bash
ish git prune sync         # bad: only 1 prune command exists
```

flatten until you have 2+ commands that justify grouping:
```bash
ish git prune              # good: single command, keep flat
```

when you have 2+ related commands, hierarchy is justified:
```bash
ish git clean prune        # good: 2+ clean commands exist
ish git clean worktrees    # hierarchy warranted by repetition
```

**the 2+ rule:** once you see repetition (2 functions with shared prefix), ignoring it is jarring. extract immediately.

### left-to-right scope narrowing

each word narrows what we're doing:

```bash
ish                         # top level: ish cli
ish git                     # git operations
ish git clean               # clean/remove cruft
ish git clean prune         # prune local branches missing on remote
```

progression is always: **general → specific → action**

this creates a natural, discoverable command structure. users intuitively understand what `ish bootstrap macos homebrew install` will do.

### let abstractions emerge

**current code represents years of battle-tested lessons.**

don't restructure prematurely:
- add features using existing patterns first
- wait for patterns to prove themselves
- extract when you see 2+ instances (no speculative generality)
- major restructuring only after proving patterns work

this is the same principle from claude.md applied to architecture: let abstractions emerge naturally rather than designing for hypothetical future needs.

### the growth pattern

**start simple, grow organically:**

**stage 1: functions in router file**
```bash
# bash/git.sh
git_clean_prune() { ... }
git_clean_worktrees() { ... }

git_route() {
  case "${1-}" in
    clean)
      # nested routing
  esac
}
```

**stage 2: extract when patterns emerge**
once you have 2+ functions with shared prefix (e.g., `git_clean_*`):
```bash
# bash/git/clean.sh - extracted module
git_clean_prune() { ... }
git_clean_worktrees() { ... }

# bash/git.sh - router sources and delegates
source "${module_dir}/git/clean.sh"
git_route() { ... }
```

**stage 3: sub-routers for directory boundaries**
only create when clean/ needs its own subdirectories.

## remote execution: the ansible alternative

**why ish over ansible?**
- no yaml configuration files
- no python dependency
- same patterns locally and remotely
- single command: `ish --remote=host bootstrap all`
- self-contained, portable

the `--remote` flag modifies where a command executes, not what it does. any ish command can run remotely with identical syntax.

## help text: concise and specific

tell users exactly what commands do:

**good:**
```bash
echo "  prune        prune local branches missing on remote"
echo "  worktrees    remove all worktrees except main"
```

**bad:**
```bash
echo "  prune        manage branches"  # too vague
echo "  worktree     worktree operations"  # doesn't tell me what it does
```

users should understand the command's purpose from help text alone.

## sizing guidelines for bash

bash is not python/ruby - different complexity thresholds apply:

**functions:**
- <15 lines: ideal for bash
- 15-30 lines: acceptable
- >30 lines: consider breaking up

**modules:**
- <100 lines: good
- 100-150 lines: warning sign
- >150 lines: extract to sub-modules

these are looser than general claude.md guidelines because bash naturally requires more lines for error handling, conditionals, and command execution.

## future: framework/project split

**let this cogitate during phase 1-2 work.**

eventually ish splits into:
- **ish-framework** - reusable core (routing, utilities, conventions)
- **ish-projects** - custom instances (your commands, your configs)

this enables:
- multiple projects using the same framework
- version pinning ("this project uses framework v1.2.3")
- shared patterns across personal infrastructure
- easy updates (update framework, all projects benefit)

but we're not there yet. current monolith contains battle-tested code. prove the patterns work before splitting.

## production parity

from claude.md general principles:
- **production is the arbiter of how things work**
- adapt dev/test to match production's constraints
- production runs on bare metal with real limitations

for ish:
- test on actual systems (macos, kali)
- bootstrap must work on fresh installs
- idempotency is critical (safe to re-run)
- no assumptions about pre-installed tools

## key tenets

1. **live off the land** - minimal dependencies, maximum portability
2. **convention over configuration** - patterns over yaml
3. **brevity** - minimum levels needed, flatten premature hierarchy
4. **let abstractions emerge** - wait for 2+ instances before extracting
5. **left-to-right narrowing** - commands read like natural language
6. **battle-tested first** - prove patterns before restructuring
7. **production parity** - test on real systems with real constraints
8. **idempotent operations** - safe to run multiple times
9. **self-contained** - copy one file, it just works
10. **remote-ready** - same commands work locally or over ssh
