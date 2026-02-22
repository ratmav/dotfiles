# refactor-packages-use-fp-core

**dependencies:** none (stream, result, file primitives are built)

**priority:** high — first consumer of the FP core

## description

Refactor ish-ratfiles and ish-kanban to use FP core primitives (stream, result, file). The primitives exist and are tested. This task applies them to package code, making composition intent explicit and replacing raw bash idioms with named FP operations.

## ish-ratfiles subtasks

**bootstrap sequences** — decide tight vs loose coupling for each `_all` function:
- [ ] `ish_ratfiles_bootstrap_posix_all` — 8 sequential calls. Which are a unit? Which are independent?
- [ ] `ish_ratfiles_bootstrap_kali_all` — 4 sequential calls (apt, rust, wezterm, posix_all)
- [ ] `ish_ratfiles_bootstrap_macos_all` — 5 sequential calls (homebrew_install, brew, cask, bash, posix_all)
- [ ] homebrew sub-routes (`all` case in macos route) — 3 sequential calls

For tight coupling, use `ish_result_and_then`. For intentionally loose coupling, leave as bare calls — the contrast documents the design.

**nix.sh** — safe output capture:
- [ ] `_nix_find_version_commit` line 91: `commits=$(_nix_get_package_commits "$path")` — exit code lost. Use `ish_result_map` or explicit `|| return $?`
- [ ] `_nix_find_version_commit` line 94: `found_version=$(_nix_get_version_from_commit ...)` — exit code lost
- [ ] `_nix_get_version_from_commit` line 113: `|| echo ""` fallback — candidate for `ish_result_or_else`

**source references:**
- [ ] `nix.sh` line 4: `source utils.sh` — should source FP core modules directly (stream, result, file) instead of legacy utils

## ish-kanban subtasks

**board.sh** — migrate legacy function names:
- [ ] `ish_utils_exists_file` → `ish_file_exists` (3 occurrences in board.sh)

**task.sh** — no changes needed (guards are fine as-is)

## deliverable

Both packages use FP core primitives. No callers of `ish_utils_exists_file` remain. Bootstrap coupling intent is explicit.
