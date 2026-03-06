#!/usr/bin/env bash

# Extension. Wraps git binary.
# Composes stream primitives around shell calls to git.
# All functions accept --dir= to target a specific repo (uses git -C).

ish_git_module_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source "${ISH_CORE}/source/exists.sh"
source "${ISH_CORE}/source/stream.sh"

source "${ish_git_module_dir}/git/error.sh"
source "${ish_git_module_dir}/git/require.sh"
source "${ish_git_module_dir}/git/add.sh"
source "${ish_git_module_dir}/git/commit.sh"
source "${ish_git_module_dir}/git/pull.sh"
source "${ish_git_module_dir}/git/push.sh"
