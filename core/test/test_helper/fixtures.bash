#!/usr/bin/env bash

# Fixture directory for test-created files and executables
ISH_TEST_FIXTURES="/tmp/ish_fixtures"

# Create a fake executable in PATH
# Usage: fixture_executable <name>
# Creates: /tmp/ish_fixtures/<name>
# Note: Use explicit suffixes in tests (e.g., "mycommand_test_bin")
#       to make it clear these are test fixtures
fixture_executable() {
  local name="${1-}"

  if [[ -z "$name" ]]; then
    echo "fixture_executable: name required" >&2
    return 1
  fi

  mkdir -p "$ISH_TEST_FIXTURES"
  local fixture_path="$ISH_TEST_FIXTURES/${name}"

  # Create executable that exits 0 (simulates command exists and succeeds)
  echo '#!/usr/bin/env bash' > "$fixture_path"
  echo 'exit 0' >> "$fixture_path"
  chmod +x "$fixture_path"

  # Prepend to PATH if not already there
  if [[ ":$PATH:" != *":$ISH_TEST_FIXTURES:"* ]]; then
    export PATH="$ISH_TEST_FIXTURES:$PATH"
  fi
}

# Create a fake file
# Usage: fixture_file <name>
# Creates: /tmp/ish_fixtures/<name>
# Note: Use explicit suffixes in tests (e.g., "myfile_test_file")
#       to make it clear these are test fixtures
fixture_file() {
  local name="${1-}"

  if [[ -z "$name" ]]; then
    echo "fixture_file: name required" >&2
    return 1
  fi

  mkdir -p "$ISH_TEST_FIXTURES"
  touch "$ISH_TEST_FIXTURES/${name}"
}

# Clean up all test fixtures
fixture_cleanup() {
  rm -rf "$ISH_TEST_FIXTURES"

  # Remove fixtures from PATH
  export PATH="${PATH//$ISH_TEST_FIXTURES:/}"
  export PATH="${PATH//:$ISH_TEST_FIXTURES/}"
}
