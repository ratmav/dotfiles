# testing

ish uses [bats-core](https://github.com/bats-core/bats-core) for automated testing. bats-core 1.5.0+ required for `run --keep-empty-lines`.

- [organization](testing/organization.md) — directory structure, mirroring, coverage philosophy
- [writing](testing/writing.md) — file structure, naming, assertions
- [fixtures](testing/fixtures.md) — fixture helpers, ISH_TESTING, no skipped tests
- [scope](testing/scope.md) — what to test, what not to test, tdd, troubleshooting

## running tests

```bash
./ish test all          # run all tests (unit + integration)
./ish test unit         # run unit tests only
./ish test integration  # run integration tests only
./ish lint all          # run shellcheck on all bash files
```
