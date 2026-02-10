# 004: enable gpg signed commits

**milestone:** 3 - framework split

**dependencies:** phase 3 task 002 (repo reboot ready)

## description

set up gpg key signing for commits to enable trusted "curl | bash" pattern for bootstrap scripts. users can verify code authenticity before running.

## subtasks

- [ ] set up gpg key for signing commits
- [ ] configure `git config --global commit.gpgsign true`
- [ ] add to bootstrap git configuration
- [ ] publish public key for verification

## key management and trust model

**Key setup:**
- [ ] Generate GPG key with no expiration
- [ ] Configure git signing: `git config --global commit.gpgsign true`
- [ ] Add to bootstrap git configuration

**Key publication:**
- [ ] Publish public key to GitHub
- [ ] Publish to personal website (HTTPS)
- [ ] Publish to Keybase
- [ ] Publish fingerprint to multiple sources (verification)
- [ ] Document: how to verify fingerprint out-of-band

**Key lifecycle:**
- [ ] Document key rotation procedure (if needed)
- [ ] Document key revocation procedure
- [ ] Test: what happens with revoked key?

**Trust model:**
- [ ] Document what's being signed (commits? tags? both?)
- [ ] Document signing policy (all commits? releases only?)
- [ ] Decide: do submodule commits need signing?
- [ ] Document air-gapped key verification process

**Package signing:**
- [ ] Decide: do installed packages need GPG signatures?
- [ ] If yes: how to verify package commits?
- [ ] If yes: trust transitivity (ish verifies, package doesn't?)

## deliverable

all commits signed, public key published

## notes

**benefit:** enables trusted remote bootstrap by allowing signature verification
