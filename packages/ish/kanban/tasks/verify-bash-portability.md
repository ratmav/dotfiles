# verify bash portability

**milestone:** 2 - fp core + cleanup

**dependencies:** phase 1 complete

## description

Ensure ish works across bash versions and platforms. Document requirements and test on multiple distros.

## subtasks

**Version requirements:**
- [ ] Audit codebase for bash version dependencies
  - `[[` requires bash 3+
  - `declare -A` requires bash 4+
  - Other bash 4+ features?
- [ ] Document minimum bash version requirement
- [ ] Add version check at ish entry point:
  ```bash
  ((BASH_VERSINFO[0] < 4)) && {
    echo "Error: bash 4+ required (found ${BASH_VERSION})" >&2
    exit 1
  }
  ```

**Cross-platform testing:**
- [ ] Test on Debian/Ubuntu (bash 5.x)
- [ ] Test on macOS (bash 3.2 by default - may fail!)
- [ ] Test on Alpine (busybox ash - if claiming POSIX)
- [ ] Test on Kali (bash 5.x)
- [ ] Document tested platforms

**Portability issues:**
- [ ] Verify `#!/usr/bin/env bash` works (env location)
- [ ] Check for GNU vs BSD differences
- [ ] Test with `set -u` (undefined variables)
- [ ] Verify no bashisms in POSIX scripts

**Documentation:**
- [ ] README: Add "Requirements" section
  - Minimum bash version
  - Tested platforms
  - Known incompatibilities (e.g., macOS default bash)
- [ ] Add to bootstrap: check bash version before proceeding

## deliverable

Documented bash version requirement. Tested on multiple platforms. Version check in place.

## critical files

- `ish` (main entry point - add version check)
- `README.md` (UPDATE - requirements section)
- `packages/ish/docs/philosophy.md` (UPDATE - portability notes)

## verification

```bash
# Version check works
BASH_VERSION=3.2 ./ish
# (should fail with clear error message)

# Works on target platforms
docker run -it debian:latest /path/to/ish help
docker run -it ubuntu:latest /path/to/ish help
docker run -it alpine:latest /path/to/ish help  # may fail - document
```

## notes

**macOS caveat:** Default bash is 3.2 (ancient). Users must install bash 5 via homebrew:
```bash
brew install bash
# Then use /opt/homebrew/bin/bash
```

Document this in bootstrap/macos.
