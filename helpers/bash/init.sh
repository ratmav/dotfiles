#!/usr/bin/env bash

helpers_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source "${helpers_dir}/_tui.sh"

tui_msg_init

source "${helpers_dir}/nix.sh"
source "${helpers_dir}/git.sh"
