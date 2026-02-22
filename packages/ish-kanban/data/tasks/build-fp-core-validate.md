# build ish_validate - validation functions and combinators

**milestone:** 2 - fp core + cleanup

**dependencies:** phase 1 (restructure complete)

## description

Build validation functions and combinators that enable clean error handling and input validation.

Pure functions that return true/false, composable with and/or/not.

## subtasks

**Basic Validators:**
- [ ] implement basic validators (nonempty, int, ip, hostname, url)
- [ ] implement combinator: `ish_validate_and` - combine with AND
- [ ] implement combinator: `ish_validate_or` - combine with OR
- [ ] implement combinator: `ish_validate_not` - negate validator
- [ ] implement `ish_validate_require` - validate or fail with message
- [ ] implement `ish_validate_make_regex` - create validator from pattern

**Namespace Validation:**
- [ ] implement `ish_namespace_validate` - check function matches declared namespace
- [ ] implement `ish_namespace_check_uniqueness` - check for duplicate namespaces
- [ ] implement `ish_namespace_parse` - parse namespace from package.conf
- [ ] implement `ish_namespace_validate_function_name` - check function naming

**Testing:**
- [ ] write unit tests for all validators
- [ ] write tests for combinator composition
- [ ] write tests for namespace validation
- [ ] document with type signatures and examples

## deliverable

`core/source/validate.sh` with composable validators

## notes

**See:** core/docs/architecture/primitives.md

**Type signatures:**
```bash
# @type: string -> bool
ish_validate_nonempty()

# @type: string -> bool
ish_validate_ip()

# @type: (a -> bool) -> (a -> bool) -> a -> bool
ish_validate_and()

# @type: (a -> bool) -> a -> string -> IO () | error
ish_validate_require()
```

**Validators are pure. require_* functions perform IO (error/exit).**

**Namespace validation functions:**
```bash
# @type: string (file) -> string (namespace) -> IO () | error
ish_namespace_validate()

# @type: [string] (namespaces) -> bool
ish_namespace_check_uniqueness()

# @type: string (conf_file) -> string (namespace)
ish_namespace_parse()
```

**Used by registry module to enforce namespace uniqueness.**
