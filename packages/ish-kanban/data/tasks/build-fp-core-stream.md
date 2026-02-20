# build ish_stream - functional stream operations

**dependencies:** build-fp-core-file-descriptor, build-fp-core-pipe

**priority:** high

## description

Build functional stream primitives (map, bind, filter, fold) that provide the foundation for composable, predictable bash code.

These are the FP building blocks everything else uses.

## subtasks

- [ ] implement `ish_stream_map` - transform each line
- [ ] implement `ish_stream_bind` - monadic composition with error propagation
- [ ] implement `ish_stream_filter` - select lines matching predicate
- [ ] implement `ish_stream_fold` - reduce stream to single value
- [ ] implement `ish_stream_stdout` - safe output to fd 1
- [ ] implement `ish_stream_stderr` - safe output to fd 2
- [ ] write unit tests for each primitive
- [ ] test functor/monad laws (identity, composition)
- [ ] document with type signatures and examples

## deliverable

`core/source/stream.sh` with tested FP primitives

## notes

**See:** core/docs/architecture/functional_future/primitives.md

**Type signatures:**
```bash
# @type: (a -> b) -> [a] -> [b]
ish_stream_map()

# @type: (a -> M b) -> M a -> M b
ish_stream_bind()

# @type: (a -> bool) -> [a] -> [a]
ish_stream_filter()

# @type: (b -> a -> b) -> b -> [a] -> b
ish_stream_fold()
```

**These primitives guarantee composition works correctly.**

**Performance characteristics:**

FP stream operations spawn processes. Understand performance implications:

- Process spawn cost: ~5ms per operation per line
- Pipeline: 3 operations × 100 lines = ~1.5s total
- Acceptable for: <1000 line datasets (typical ish use case)
- Problem scenario: 10,000 line file × 5 operations = ~250s (too slow)

**Mitigation strategies:**
- Target use case: small datasets (dotfiles, host inventories ~10-100 items)
- Hot paths: Use awk/sed for bulk operations if needed
- Document performance in function comments
- Add perf tests: time operations on 100/1000/10000 line inputs

**Testing:**
- [ ] Unit tests for correctness
- [ ] Performance tests for scale understanding
- [ ] Document acceptable dataset sizes
