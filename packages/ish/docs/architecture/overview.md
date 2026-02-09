# ish Architecture: Module Registry & Package System

## Overview

This document describes the architecture for ish's module registry and package system, enabling remote module discovery, installation, and loading.

**Core Philosophy:**
- Composition over inheritance (peer dependencies, not parent/child)
- Always be upgrading (HEAD of main, not version pinning)
- Namespace via git VCS (service/user/repo uniqueness)
- Plain text scripts (no build/compile/install distinction)
- Clone, verify, use (no `curl | bash`)
- Extensible CLI via domains (packages add functionality)

**CLI Design:**

All commands follow the pattern: `ish <domain> <action> [--options]`

**Domains are either:**
1. **Meta domains** (ish core) - manage ish itself
   - `ish package install` - package management
   - `ish register add` - registry management
   - `ish self verify` - self-maintenance

2. **Feature domains** (from packages) - package functionality
   - `ish kanban show` - from ish package
   - `ish bootstrap macos` - from dotfiles package
   - `ish docker build` - from hypothetical docker package

**Key insight:** Packages extend the CLI by adding new domains. The syntax stays consistent regardless of which package provides the functionality.

---

## Installation & Trust Model

### No `curl | bash`

**Traditional approach (rejected):**
```bash
curl https://example.com/install.sh | bash  # ❌ Don't do this
```

**ish approach (after repo split):**
```bash
# 1. Clone (inspect before execute)
git clone https://github.com/ratmav/ish.git
cd ish

# 2. Inspect (plain text, auditable)
cat bin/ish
less source/registry.sh
# Read whatever you want - it's all bash

# 3. Verify signatures
./bin/ish self verify
# ✓ Verified GPG signature on HEAD commit
# ✓ Commit abc123... signed by ratmav <fingerprint>

# 4. Install globally
./bin/ish self install
# ✓ Copied ish to ~/.local/bin/ish
# ✓ Added ~/.local/bin to PATH in ~/.bashrc

# 5. Use it
ish package install --namespace=github/ratmav/dotfiles
```

### Trust Model

**What you're trusting:**
1. **Git** - Cryptographic integrity (content-addressable storage, SHA verification)
2. **Git hosting** - Correct repository (GitHub/GitLab/etc.)
3. **GPG key** - Specific fingerprint verified out of band

**What you're NOT trusting:**
- Any web server to execute code for you
- Any intermediate transport during execution
- Any hidden build process
- Any binary blobs

**Verification chain:**
- Git clone → Ensures content integrity (SHA-based)
- GPG signature → Ensures commit identity (who signed it)
- Out-of-band verification → Ensures key authenticity (published fingerprint matches)

**How to verify GPG key fingerprint:**
- Published on personal website (HTTPS)
- Published on Keybase
- Published on multiple platforms
- Verified in person / via trusted network
- Web of trust

### Advantages Over `curl | bash`

| Aspect | `curl \| bash` | `git clone; ish self verify` |
|--------|----------------|------------------------------|
| **Inspection** | No (code executes during download) | Yes (code on disk before execution) |
| **Verification** | HTTPS only | Git SHA + GPG signature |
| **Auditability** | Ephemeral (piped to bash) | Persistent (files on disk) |
| **Attack Surface** | MITM, server compromise | Compromised GPG key only |
| **Trust Anchor** | Web server | GPG public key |
| **Revocation** | None | GPG key revocation possible |

### Why This Works

**1. Inspect Before Execute**
- Code is on disk before running anything
- No MITM window during "pipe to bash"
- Can read every line if desired
- Aligns with ish philosophy (plain text, auditable)

**2. Git Provides Integrity**
- Git verifies object integrity during clone
- SHA-based content addressing
- If SHA matches, content is exact
- No tampering possible post-clone

**3. GPG Provides Identity**
- Verifies: "This commit was signed by ratmav"
- Trust anchor: GPG public key verified out of band
- Not bootstrapping trust, confirming identity

**4. No Special Bootstrap**
- `ish self verify` is just another ish command
- Same code path as everything else
- No separate install script to maintain

## Design Decisions

### 1. Registry Format

**Decision:** Space-separated values

**Rationale:**
- Simple, no parsing complexity
- Grep-able and awk-able
- No tabs (avoid make-style ambiguity)
- Fields don't contain spaces (namespace is slash-separated, paths are absolute under known prefix)

### 2. Package Naming

**Decision:** Namespace via `service/user/repo`

**Rationale:**
- Leverages existing git VCS uniqueness constraints
- No central registry needed
- Clear ownership and provenance
- Examples: `github/ratmav/ish`, `gitlab/foo/bar`

### 3. Checksum Strategy

**Decision:** Git commit SHA of HEAD

**Rationale:**
- Simple - already tracked by git
- Built-in verification via `git rev-parse HEAD`
- Used only during install/update, not runtime
- Plain text scripts don't need build artifacts

### 4. Module Loading Strategy

**Decision:** Source all packages on startup

**Rationale:**
- Simpler implementation
- Aligns with current behavior
- Performance acceptable (bash sources are fast)
- Future: Lazy load if performance becomes issue

### 5. Package Validation Strategy

**Decision:** Strict on `source/`, `test/`, and `docs/`; optional on `data/`

**Rationale:**
- `source/` is required for package to function
- `test/` is required for quality assurance
- `docs/` is required for usability
- `data/` is optional - most packages won't have package-specific data
- Fail installation if required directories missing

### 6. Versioning Strategy

**Decision:** Always pull HEAD of main, no version pinning

**Rationale:**
- Philosophy: "always be upgrading"
- Reduces complexity (no version resolution)
- Future: Git tags for semver if needed
- Users can pin by forking repos

### 7. Dependency Strategy

**Decision:** Flat peer dependencies (composition, not inheritance)

**Rationale:**
- All packages install to same directory
- No parent/child relationships
- Prevents DAG complexity
- Easier to reason about
- Consistent with ish philosophy

---

## Open Questions

1. ~~How does `ish` entry point determine dev vs installed mode?~~
   - **Resolved:** False dichotomy. Plain text scripts work from anywhere. No distinction needed.

2. ~~Should registry support multiple versions of same package?~~
   - **Resolved:** No. Pull HEAD of main. Maybe git tags later, but start simple.

3. ~~Should packages declare dependencies on other packages?~~
   - **Resolved:** Yes. Via `package_self_dependencies()` function. Flat peer dependencies only.

4. ~~How to handle package namespace collisions?~~
   - **Resolved:** Rely on git VCS uniqueness (`service/user/repo`) + function naming conventions.

5. ~~Should the registry track "enabled" vs "installed" packages?~~
   - **Resolved:** No. Flat file scripts - if it's on disk in packages/, it's loaded. No debug symbols or build modes.

6. **NEW:** How to handle package updates when local changes exist?
   - Warn on dirty git state?
   - Stash changes automatically?
   - Require clean state for update?

7. **NEW:** Should packages be able to declare optional vs required dependencies?
   - Start with all required?
   - Add optional later if needed?

8. **NEW:** How to handle bootstrap package special case?
   - Bootstrap contains ish entry point initially
   - After split, how does ish find core before packages loaded?
   - Chicken-and-egg problem?

---

## Next Steps

1. Review this architecture document
2. Refine design decisions
3. Answer remaining open questions
4. Begin Step 1: Restructure current repo
5. Implement and test incrementally
