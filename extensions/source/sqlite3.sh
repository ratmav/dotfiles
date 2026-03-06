#!/usr/bin/env bash

# Extension. Wraps sqlite3 binary.
# Composes stream + file primitives around shell calls to sqlite3.

ish_sqlite3_module_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source "${ISH_CORE}/source/escape.sh"
source "${ISH_CORE}/source/exists.sh"
source "${ISH_CORE}/source/file.sh"
source "${ISH_CORE}/source/stream.sh"

source "${ish_sqlite3_module_dir}/sqlite3/error.sh"
source "${ish_sqlite3_module_dir}/sqlite3/require.sh"
source "${ish_sqlite3_module_dir}/sqlite3/escape.sh"
source "${ish_sqlite3_module_dir}/sqlite3/params.sh"
source "${ish_sqlite3_module_dir}/sqlite3/exec.sh"
source "${ish_sqlite3_module_dir}/sqlite3/query_one.sh"
source "${ish_sqlite3_module_dir}/sqlite3/transaction.sh"
source "${ish_sqlite3_module_dir}/sqlite3/dump.sh"
source "${ish_sqlite3_module_dir}/sqlite3/load.sh"
