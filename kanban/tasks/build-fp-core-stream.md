# build ish_core_stream - functional stream operations

**milestone:** 2 - fp core + cleanup

**dependencies:** phase 1 (restructure complete)

## description

Build functional stream primitives (map, bind, filter, fold) that provide the foundation for composable, predictable bash code.

These are the FP building blocks everything else uses.

## subtasks

- [ ] implement `ish_core_stream_map` - transform each line
- [ ] implement `ish_core_stream_bind` - monadic composition with error propagation
- [ ] implement `ish_core_stream_filter` - select lines matching predicate
- [ ] implement `ish_core_stream_fold` - reduce stream to single value
- [ ] implement `ish_core_stream_stdout` - safe output to fd 1
- [ ] implement `ish_core_stream_stderr` - safe output to fd 2
- [ ] write unit tests for each primitive
- [ ] test functor/monad laws (identity, composition)
- [ ] document with type signatures and examples

## deliverable

`packages/ish/source/core/stream.sh` with tested FP primitives

## notes

**See:** docs/architecture/functional_future/overview.md lines 914-997

**Type signatures:**
```bash
# @type: (a -> b) -> [a] -> [b]
ish_core_stream_map()

# @type: (a -> M b) -> M a -> M b
ish_core_stream_bind()

# @type: (a -> bool) -> [a] -> [a]
ish_core_stream_filter()

# @type: (b -> a -> b) -> b -> [a] -> b
ish_core_stream_fold()
```

**These primitives guarantee composition works correctly.**
