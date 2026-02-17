# build ish_semantic - semantic wrappers for clean code

**milestone:** 2 - fp core + cleanup

**dependencies:** build-fp-core-stream, build-fp-core-validate

## description

Build semantic wrappers that hide FP machinery behind English-like names. This is the translation layer that makes code read naturally.

Wraps stream operations, validation, and error handling with clear, semantic names.

## subtasks

- [ ] implement `ish_parse_option` - extract command-line options
- [ ] implement `ish_require_*` family - semantic validators
  - ish_require_valid_hostname
  - ish_require_valid_ip
  - ish_require_file_exists
  - ish_require_executable_exists
- [ ] implement error handling: `ish_fail_with` - error and exit
- [ ] implement user communication:
  - `ish_inform_user` - info message
  - `ish_warn_user` - warning message
- [ ] write unit tests for each semantic wrapper
- [ ] write integration tests showing readable code patterns
- [ ] document usage patterns with examples

## deliverable

`core/source/semantic.sh` with English-like wrappers

## notes

**See:** docs/architecture/functional_future/overview.md lines 858-912

**Example usage:**
```bash
# Instead of: ish_validate_require ish_validate_hostname "$hostname" "invalid"
ish_require_valid_hostname "$hostname"

# Instead of: utils_tui_info --message="testing connectivity"
ish_inform_user "testing connectivity"

# Instead of: utils_tui_error --message="cannot connect"
ish_fail_with "cannot connect"
```

**This layer makes code read like English while using FP primitives underneath.**

**CRITICAL:** All functions namespaced with `ish_*` to prevent package collisions.
