# test scope

## what to test

when adding new functionality, test these aspects:

**1. happy path:**
- function produces expected output
- message is written, file is created, command executes

**2. error conditions:**
- errors when required options missing (`--message`, `--path`, etc.)
- errors on unknown/invalid options
- errors on invalid input values
- error messages are clear and actionable

**3. edge cases:**
- empty inputs (when valid)
- special characters in inputs
- boundary conditions

**4. help text consistency:**
- help text matches actual command behavior
- all commands listed in help are implemented
- all required options documented

**5. environment handling:**
- ISH_TESTING flag uses fixtures when true
- production paths used when false
- no hardcoded paths (use module_dir)

**6. integration:**
- command works through full routing stack
- output format correct for piping/scripting
- exit codes correct (0 = success, 1 = error)

## what not to test

**don't test external tools or bash primitives:**
- external installers — we can't control their behavior
- network operations — unreliable and slow
- standard bash commands — trust the shell

**don't duplicate coverage:**
- if a function is unit tested, don't retest it through cli routing
- integration tests verify routing + composition, not individual function logic

**don't test implementation details:**
- test behavior (what it does), not implementation (how it does it)
- test public apis, not internal helper functions

**when in doubt:**
- am i testing our code or bash/external tools?
- is this already covered by unit tests?
- would deleting this test leave a gap in coverage?
- if the answer is "no gap", delete the test

## test-driven development

when adding new features:

1. **write the test first** (it will fail)
2. **implement minimum code** to make it pass
3. **refactor** while keeping tests green
4. **add edge cases** as you discover them

**when to use tdd:**
- new utilities or abstractions
- bug fixes (write test that reproduces bug, then fix)
- refactoring critical code (tests verify behavior unchanged)

**when to skip tdd:**
- exploratory work (spike, then test)
- trivial changes (formatting, comments)

## troubleshooting

**tests fail with "command not found":**
```bash
git submodule update --init --recursive
```

**tests fail with path errors:**
verify `load` paths in tests match directory structure:
- from `test/unit/`: use `'../test_helper/common-setup'`
- from `test/integration/`: use `'../test_helper/common-setup'`
