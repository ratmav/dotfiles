# kanban cli workflow

## current commands

```bash
# board
ish kanban show                          # render board.md

# tasks
ish kanban task list                     # list task names
ish kanban task new --name=NAME          # create task file
ish kanban task show --name=NAME         # output task content
ish kanban task path --name=NAME         # output task file path
ish kanban task delete --name=NAME       # delete task file

# scratch pad
ish kanban scratch show                  # output scratch content
ish kanban scratch capture --message=MSG # append to scratch
ish kanban scratch path                  # output scratch file path
```

editing is done in vim via `path` commands — see [vim_integration.md](vim_integration.md).

## future commands (sqlite redesign)

```bash
# task body via flag or stdin
ish kanban task new --name=NAME --body="description"
ish kanban task new --name=NAME < spec.md

# dependencies
ish kanban task link --name=NAME --depends-on=OTHER
ish kanban task unlink --name=NAME --depends-on=OTHER

# board view (computed from dependency graph)
ish kanban board
```

## stdin detection (future)

when no `--body` flag is provided, check stdin:

```bash
if [ -n "${body-}" ]; then
    :
elif [ ! -t 0 ]; then
    body=$(cat)
else
    body=""
fi
```

no `$EDITOR` invocation. ever.

## slug generation

task id (slug) is the `--name` value, already lowercase and hyphenated by convention.

## flag parsing

all flags use `--name=value` format (equals sign, no space):

```bash
while [[ $# -gt 0 ]]; do
    case $1 in
        --name=*) name="${1#*=}"; shift ;;
        --message=*) message="${1#*=}"; shift ;;
        *) ish_tui_error --message="unknown option: $1" ;;
    esac
done
```

## exit codes

- 0: success
- 1: error (missing flags, task not found, duplicate name)

errors go to stderr via `ish_tui_error`. data goes to stdout.
