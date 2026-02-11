## Registry Commands

### Command Hierarchy (Dependency Order)

#### `ish package` (Depends on: core utils + git)

Manages packages. Registry file (`~/.ish/core/data/registry.txt`) is internal - users interact via package commands.

**Commands:**

```bash
ish package add <url>
```
- Validate git URL format (ssh or https)
- Extract package name from URL (last component before `.git`)
  - `https://github.com/ratmav/ish-dotfiles.git` → `ish-dotfiles`
  - `git@github.com:user/ish-docker.git` → `ish-docker`
- Check for naming collision (package name already exists)
- Clone to `~/.ish/packages/<package-name>/`
- Validate package:
  - Required structure: `source/`, `test/`, `docs/`
  - GPG signed commits (must all be signed)
  - Run package tests (must pass)
  - Run linting (must pass)
- If validation fails: remove clone, fail command
- If validation passes: add URL to `~/.ish/core/data/registry.txt`

```bash
ish package remove <name-or-url>
```
- Remove from `~/.ish/packages/`
- Remove from registry
- Warn if other packages depend on this one

```bash
ish package list
```
- Read `~/.ish/core/data/registry.txt`
- For each URL, show: package name (extracted), URL

```bash
ish package update <package-name>
```
- Git pull in `~/.ish/packages/<package-name>/`
- Validate:
  - GPG signed commits (all new commits must be signed)
  - Run tests (must pass)
  - Run linting (must pass)
- If validation fails: warn (don't auto-remove)
- If validation passes: update complete

```bash
ish package scaffold --name=NAME [--with-data]
```
- **Purpose:** Create a new package with standard structure and hello world example
- **Use case:** Scaffold a new ish package from template
- **Process:**
  1. Create directory structure: `packages/<name>/`
  2. Generate hello world example function
  3. Generate `source/self/` module with test and lint commands
  4. Create `test/` with test for hello world function
  5. Create `docs/` with README and usage examples
  6. Optionally create `data/` if `--with-data` flag provided
- **Generated structure:**
  ```
  packages/<name>/
  ├── source/
  │   ├── hello.sh         # Example: name_hello() function
  │   └── self/
  │       ├── test.sh      # Auto-generated test runner
  │       └── lint.sh      # Auto-generated linter
  ├── test/
  │   └── hello.bats       # Test for name_hello() function
  ├── docs/
  │   └── README.md        # Usage examples and documentation
  └── data/                # Only if --with-data flag used
  ```
- **Example generated code:**
  ```bash
  # packages/foo/source/hello.sh
  foo_hello() {
    echo "Hello from foo package!"
  }

  # packages/foo/test/hello.bats
  @test "foo_hello outputs greeting" {
    result="$(foo_hello)"
    [ "$result" = "Hello from foo package!" ]
  }
  ```
- **Future enhancement:** Provides working example for users creating their own packages

#### `ish self` (Depends on: core utils + git)

Self-maintenance and verification commands.

**Commands:**

```bash
ish self verify [options]
```
- **Purpose:** Verify cryptographic integrity and authenticity before first use
- **Use case:** Run immediately after cloning ish repository
- **Dependencies:** Requires GPG signed commits infrastructure
- **Options:**
  - (default): Verify ALL commits (most thorough, secure by default)
  - `--head-only`: Verify HEAD commit only (fastest)
  - `--depth=N`: Verify last N commits (configurable thoroughness)
  - `--since-tag`: Verify all commits since last git tag
- **Process:**
  1. Check git repository integrity (verify we're in a git repo)
  2. Verify commit GPG signatures based on option:
     - Default: `git log --show-signature` for all commits
     - `--head-only`: `git verify-commit HEAD`
     - `--depth=N`: Verify last N commits
     - `--since-tag`: Verify commits since `git describe --tags --abbrev=0`
  3. Extract signer fingerprint(s) and display
  4. Verify package structure (source/, test/, docs/)
  5. Run all package tests
  6. Display verification results
- **Output (default --all mode):**
  ```
  ✓ Repository integrity: OK
  ✓ Verified 247 commits, all signed by ratmav <ABCD1234EFAB5678...>
  ✓ Package structure: OK
  ✓ All tests passing (42 tests, 0 failures)

  Verify GPG key fingerprint out of band:
    - https://ratmav.dev/gpg.txt
    - https://keybase.io/ratmav
  ```
- **Output (--head-only mode):**
  ```
  ✓ Repository integrity: OK
  ✓ HEAD commit abc123... signed by ratmav <ABCD1234EFAB5678...>
  ⚠ Note: Only HEAD verified. Use --all for full history verification.
  ✓ Package structure: OK
  ✓ All tests passing (42 tests, 0 failures)
  ```
- **Exit codes:**
  - 0: All verifications passed
  - 1: Verification failed (unsigned commit, test failure, etc.)
- **Security note:** Default behavior (--all) provides strongest guarantee but is slower on large repos. Use `--head-only` for quick verification with reduced security guarantee.

```bash
ish self install [--config=PATH]
```
- **Purpose:** Install ish to ~/.ish/core/ and ensure it's in PATH
- **Use case:** After cloning and verifying ish, make it globally available
- **Options:**
  - `--config=PATH`: Specify config file (e.g., `~/.zshrc`, `~/.config/fish/config.fish`)
  - Default: `~/.bashrc`
- **Process:**
  1. Clone/copy framework to `~/.ish/core/`
  2. Detect current shell via `$SHELL` (if no `--config` specified)
  3. Prompt user to confirm config file or choose alternative:
     ```
     Detected shell: bash
     Install to ~/.bashrc? (y/n/other):
     ```
  4. Check if config file already includes `~/.ish/core/bin` in PATH
  5. If not present, add using `ish_filesystem_line_in_file`: `export PATH="$HOME/.ish/core/bin:$PATH"`
  6. Confirm installation successful
- **Output:**
  ```
  ✓ Installed ish to ~/.ish/core/
  ✓ Added ~/.ish/core/bin to PATH in ~/.bashrc

  Run: source ~/.bashrc
  Then: ish --version
  ```
- **Updates:** Re-run `ish self install` to update the installed copy

```bash
ish self test
```
- Run all tests for current package
- Existing functionality (already implemented)

```bash
ish self lint
```
- Run linters for current package
- Existing functionality (already implemented)
