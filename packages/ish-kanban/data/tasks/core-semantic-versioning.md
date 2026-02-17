# core-semantic-versioning

**milestone:** 6 - split repos

**dependencies:** split repos complete, implement-registry

**priority:** high

## description

Extend the existing package install and validation pipeline with ish core semantic versioning. After repos are split, packages declare which core version they depend on via their `.conf` metadata.

Builds on existing design:
- Registry `.conf` metadata already has a `version` field for package version
- `ish package install` already validates namespace at install time
- `ish registry validate` already runs in CI

Adds:

1. **ish core version tags** - tag ish core repo with semver (e.g., `v1.0.0`). Breaking changes to core utilities bump major, new functions bump minor, bug fixes bump patch.

2. **package core dependency** - add `core_version` field to package `.conf` metadata. Example:
   ```bash
   # registry/data/packages/ish_kanban.conf
   namespace="ish_kanban"
   repo="https://github.com/ratmav/ish-kanban.git"
   author="ratmav"
   version="0.1.0"
   core_version="1"
   description="Kanban board and task management"
   ```

3. **install-time validation** - extend `ish_package_install_from_registry` to check that the package's `core_version` matches the running core's major version. Same major required; different minor/patch is fine.

4. **core test/lint validation** - extend `ish test` and `ish lint` to confirm all installed packages depend on a compatible core version (same major). Catches version drift in CI before users hit it.

5. **`ish version` command** - expose core version for scripts and humans.

## deliverable

- Semantic version tags on ish core repo
- `core_version` field in package `.conf` metadata
- `ish version` command
- Compatibility check in `ish package install` (same major version)
- Compatibility check in `ish test`/`ish lint` (same major version)
- Tests for version validation
