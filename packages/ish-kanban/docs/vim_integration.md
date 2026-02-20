# vim integration

## native vim (works now)

vim's `:w !` and `:r !` are the pipeline. no plugins required.

### create a task with body (future: sqlite redesign)

write the spec in a buffer, then:

```vim
:w !ish kanban task new --name=implement-parser
```

pipes the buffer to stdin. ish reads it as the body.

### edit an existing task

get the file path, open it:

```vim
:r !ish kanban task path --name=implement-parser
```

or view task content in a buffer:

```vim
:r !ish kanban task show --name=implement-parser
```

### visual selection

pipe just the selected lines:

```vim
:'<,'>w !ish kanban task new --name=implement-parser
```

### view the board

```vim
:r !ish kanban show
```

## neovim plugin: `:Ish` (future)

modeled after fugitive's `:Git` — one command, CLI parity. use the archived epoch plugin as a starting point for floating window behavior and plugin structure.
