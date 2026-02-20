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

## trust model

no `curl | bash`. code is on disk before execution.

```bash
git clone https://github.com/ratmav/ish.git
cd ish
# inspect — plain text, auditable
ish validate    # git integrity, gpg signatures, keyserver, structure, tests
ish install     # add ~/.ish/core/bin to $PATH
```

**what you're trusting:**
- **git** — content integrity (sha-based, content-addressable)
- **gpg** — commit identity (who signed it)
- **out-of-band verification** — key authenticity (published fingerprint matches)

**what you're not trusting:**
- any web server to execute code for you
- any intermediate transport during execution
- any hidden build process or binary blobs

**advantages over `curl | bash`:**

| aspect | `curl \| bash` | `git clone; ish validate` |
|--------|----------------|---------------------------|
| inspection | no (executes during download) | yes (files on disk first) |
| verification | HTTPS only | git sha + gpg signature |
| auditability | ephemeral (piped) | persistent (files on disk) |
| trust anchor | web server | gpg public key |
