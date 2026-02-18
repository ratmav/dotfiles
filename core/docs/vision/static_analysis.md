# convention enforcement through static analysis

**the problem:** conventions in `docs/conventions/` are only enforced through code review and runtime failures. bugs from convention violations (like module_dir variable collisions) slip through.

**the solution:** custom static analysis rules that encode architectural constraints as checkable rules.

## custom checks

1. **module_dir namespacing** — detect bare `module_dir=` declarations (should be `ish_foo_module_dir=`). prevents variable collisions when modules source each other. real bug caught: tui.sh defining `module_dir` clobbered another module's value.

2. **dag validation** — analyze source statements to build dependency graph. detect circular dependencies. enforce unidirectional flow (only source peers or children, never parents).

3. **function naming conventions** — verify functions match file path (`source/foo/bar.sh` → `ish_foo_bar_*` functions). detect functions in wrong files.

4. **explicit routing pattern** — ensure routable modules have `*_route()` functions. verify routes dispatch to functions, not inline code.

5. **sourcing patterns** — validate `*_module_dir` initialization. ensure source statements use absolute paths. prevent brittle relative path sourcing.

## implementation

**shellcheck custom rules status** (ref: https://github.com/koalaman/shellcheck/issues/1061)
- shellcheck does not currently support a plugin/extension system
- custom rules require changes to the shellcheck engine itself (haskell)
- **decision: fork shellcheck or build standalone analyzer**

**alternatives:**
- standalone bash script analyzer (parse bash ast, apply rules)
- grep-based checks (fragile but better than nothing)
- wrapper around shellcheck + custom post-processing
- fork shellcheck with ish-specific rules

```bash
# integration target
ish lint all  # runs shellcheck + custom rules
```

## benefits

- **catch bugs early** — violations detected at lint time, not runtime
- **self-documenting** — rules encode the "why" behind conventions
- **refactoring confidence** — static validation makes changes safer
- **convention evolution** — guidelines become guarantees

**precedent:** eslint (custom plugins), rubocop (custom cops), go vet (custom analyzers)

**timeline:** post-milestone 4 (long-term). high effort but high value — architectural guarantees prevent entire classes of bugs.
