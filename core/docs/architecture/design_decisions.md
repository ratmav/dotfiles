# design decisions

## registry format

space-separated flat file in ish core. grep-able, awk-able. no tabs. fields don't contain spaces.

## package naming

flat names (`ish-kanban`, `ish-ratfiles`). registry file lives in ish core. new packages tracked via pull requests.

## verification

three-layer check:

1. **git sha** — content integrity
2. **all commits signed** — identity chain (every commit, not just HEAD)
3. **pgp key on keyserver** — automated trust anchor verification

users validate ish manually first (inspect code, run checks themselves), install, then use `ish validate` to validate ish going forward. ish validates packages automatically during install using the same logic.

## module loading

source all packages on startup until there's an issue.

## package validation

fail installation if:
- required directories missing (`source/`, `test/`, `docs/`)
- any test fails

`data/` is optional.

## versioning

HEAD of main for now. semver via git tags later (see `core-semantic-versioning` task).

## dependencies

flat peer dependencies. all packages install to same directory. no parent/child relationships. composition, not inheritance.
