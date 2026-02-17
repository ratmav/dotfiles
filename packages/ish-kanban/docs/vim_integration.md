# vim integration

## native vim (works now)

vim's `:w !` and `:r !` are the pipeline. no plugins required.

### create a task with body

write the spec in a buffer, then:

```vim
:w !ish kanban task new --title "implement parser"
```

pipes the buffer to stdin. ish reads it as the body.

### edit an existing task

pull the task body into a buffer:

```vim
:r !ish kanban task show --id kanban-sqlite-redesign
```

edit the buffer, then write it back:

```vim
:w !ish kanban task edit --id kanban-sqlite-redesign
```

### visual selection

pipe just the selected lines:

```vim
:'<,'>w !ish kanban task new --title "implement parser"
```

### view the board

```vim
:r !ish kanban board
```

## neovim plugin: `:Ish` (future)

modeled after fugitive's `:Git` — one command, CLI parity. use the archived epoch plugin as a starting point for floating window behavior and plugin structure.
