#!/usr/bin/env bash

# Integration layer. Wraps sqlite3 binary.
# Composes stream + file primitives around shell calls to sqlite3.

ish_sqlite_module_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source "${ish_sqlite_module_dir}/exists.sh"
source "${ish_sqlite_module_dir}/file.sh"
source "${ish_sqlite_module_dir}/stream.sh"

source "${ish_sqlite_module_dir}/sqlite/error.sh"
source "${ish_sqlite_module_dir}/sqlite/require.sh"
source "${ish_sqlite_module_dir}/sqlite/escape.sh"
source "${ish_sqlite_module_dir}/sqlite/exec.sh"
source "${ish_sqlite_module_dir}/sqlite/query.sh"
source "${ish_sqlite_module_dir}/sqlite/query_one.sh"
source "${ish_sqlite_module_dir}/sqlite/transaction.sh"
source "${ish_sqlite_module_dir}/sqlite/dump.sh"
source "${ish_sqlite_module_dir}/sqlite/load.sh"
