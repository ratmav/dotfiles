# registry commands

## registry

the registry file (`core/data/registry.txt`) is a curated list of known packages, managed through pull requests to ish core. package authors submit PRs to add their packages. users don't modify it directly.

## ish package

```bash
ish package add <name>
```
- look up package in registry
- clone to `~/.ish/packages/<name>/`
- validate: required structure, all commits signed, tests pass, lint passes
- if validation fails: remove clone, fail

```bash
ish package remove <name>
```
- remove package from `~/.ish/packages/`

```bash
ish package list
```
- show installed packages

```bash
ish package update <name>
```
- record current sha (rollback point; later, pre-upgrade semver tag)
- git pull
- validate: signed commits, tests pass, lint passes
- if validation fails: rollback to recorded sha, warn

```bash
ish package scaffold --name=NAME [--with-data]
```
- create standard package structure with hello world example
- generate `source/`, `test/`, `docs/`
- optionally create `data/` if `--with-data`

## ish validate

```bash
ish validate
```
- check git repository integrity
- verify all commit gpg signatures
- verify gpg key on keyserver
- validate package structure
- run all tests
- same logic reused by `ish package add` and `ish package update`

## ish install

```bash
ish install [--config=PATH]
```
- add `~/.ish/core/bin` to `$PATH` in shell config
- default: `~/.bashrc`
- `--config=PATH`: specify alternate config file
- idempotent
