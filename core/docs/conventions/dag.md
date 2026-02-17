# dag architecture: the foundation

**the entire codebase is a directed acyclic graph (dag).**

this isn't just a nice property - it's the architectural foundation that makes everything else work.

## what is the dag?

nodes in the graph are modules (files). edges are dependencies (source statements).

```
source/tui.sh ──sources──> source/exists.sh
              ──sources──> source/tui/template.sh

source/tui/template.sh ──uses──> ish_tui_error (from parent)
```

**directed**: dependencies flow in one direction (parent → child, never child → parent)

**acyclic**: no circular dependencies - you cannot have a path from a module back to itself

## why dag structure?

**prevents circular dependencies by construction:**
- parent sources child
- child uses functions parent already loaded
- child cannot source parent (would violate directory hierarchy)
- impossible to create cycles if you follow conventions

**makes reasoning about code trivial:**
- dependency order is explicit (topological sort of the dag)
- no hidden coupling - all edges visible in source statements
- local changes have bounded impact (only descendants affected)
- can reason about any module in isolation (just trace its ancestors)

**enables safe refactoring:**
- change a function signature? grep for callers (they're descendants)
- extract a module? just update parent's source statements
- merge modules? combine source statements, preserve dag
- no surprises - the graph tells you what touches what

## directory structure enforces dag

the parent/child relationship in directories mirrors the dag structure:

```
source/
├── foo.sh              # parent node
└── foo/
    └── bar.sh          # child node

parent sources child. child uses parent's functions. acyclic by construction.
```

**rules enforced by structure:**
1. **parents source children** - `foo.sh` sources `foo/bar.sh`
2. **children use parent functions** - `bar.sh` calls functions parent defined
3. **siblings source shared dependencies** - both source a common module if needed
4. **no child-to-parent edges** - child cannot source parent (directory hierarchy prevents it)

## breaking the dag is a design smell

**cycles indicate coupling.** the urge to create a cycle is the architecture telling you something.

**reaching across to peer modules signals a hidden parent abstraction.** if module A and module B both need each other's functions, they either belong together (merge) or they both depend on something that doesn't exist yet (extract).

| symptom | diagnosis | treatment |
|---|---|---|
| child needs parent's function | not a problem — parent loaded it first | just use it |
| parent needs child's function | function is in the wrong place | move to parent or extract to sibling |
| two modules need each other | they're one module, or both need a third | merge or extract shared dependency |
| cross-cutting concern | abstraction crosses dag boundaries | extract to separate library |

**the dag is the architecture.** everything else (routing, naming, growth pattern) exists to support the dag structure.
