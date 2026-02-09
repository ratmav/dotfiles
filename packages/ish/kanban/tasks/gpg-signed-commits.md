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

## deliverable

all commits signed, public key published

## notes

**benefit:** enables trusted remote bootstrap by allowing signature verification
