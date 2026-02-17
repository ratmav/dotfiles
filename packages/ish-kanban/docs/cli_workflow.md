# kanban cli workflow

## task lifecycle

```bash
# create — --title is required, --body is optional
ish kanban task new --title "implement parser"
ish kanban task new --title "implement parser" --body "detailed description here"
ish kanban task new --title "implement parser" < spec.md

# read
ish kanban task show --id kanban-board-parser
ish kanban task list

# update
ish kanban task edit --id kanban-board-parser --body "new body"
ish kanban task edit --id kanban-board-parser < spec.md

# done — deletes the task. git log is the historical record.
ish kanban task delete --id kanban-board-parser
```

## dependencies

```bash
# link: "parser" depends on "validation"
ish kanban task link --id parser --depends-on validation

# unlink: remove dependency
ish kanban task unlink --id parser --depends-on validation
```

## board view

```bash
ish kanban board
```

output groups tasks by computed state. open = no dependencies. blocked = has dependencies.

```
open:
  kanban-sqlite-redesign
  fix-lint-command

blocked:
  kanban-migration          <- depends on: kanban-sqlite-redesign
```

multiple open tasks can exist at once. you pick which to work on.

## stdin detection

when no `--body` flag is provided, check stdin:

```bash
if [ -n "${body-}" ]; then
    # --body flag was provided
    :
elif [ ! -t 0 ]; then
    # stdin is piped — read body from it
    body=$(cat)
else
    body=""
fi
```

no `$EDITOR` invocation. ever.

## slug generation

task id (slug) is derived from the title:

```bash
# "Implement Board Parser" -> "implement-board-parser"
slug=$(echo "$title" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd 'a-z0-9-')
```

slugs are the primary key. title uniqueness (enforced by the schema) guarantees slug uniqueness.

## flag parsing

all flags use `--name value` format (space-separated, not `=`). parsed with a while/case loop:

```bash
while [ $# -gt 0 ]; do
    case "$1" in
        --title) title="$2"; shift 2 ;;
        --id)    id="$2";    shift 2 ;;
        --body)  body="$2";  shift 2 ;;
        --depends-on) depends_on="$2"; shift 2 ;;
        *) ish_utils_tui_error "unknown flag: $1" ;;
    esac
done
```

## exit codes

- 0: success
- 1: error (missing flags, task not found, duplicate title, circular dep)

errors go to stderr via `ish_utils_tui_error`. data goes to stdout.
