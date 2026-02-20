#!/usr/bin/env bash

ish_kanban_board_parse() {
  local board_file
  board_file="$(ish_packages_data_dir "ish-kanban")/board.md"

  ish_utils_exists_file --file="$board_file" || ish_tui_error --message="board not found: $board_file"
  ish_exists_executable --executable=awk || ish_tui_error --message="awk required"

  awk '
  /^## phase [0-9]+:/ {
    milestone = $3
    sub(/:$/, "", milestone)
    section = ""
    next
  }
  /^### todo/ { section = "todo"; next }
  /^### in progress/ { section = "in_progress"; next }
  /^### completed/ { section = "completed"; next }
  /\]\(tasks\/.*\.md\)/ {
    if (milestone != "" && section != "") {
      prefix = substr($0, 1, index($0, "](tasks/") - 1)
      n = split(prefix, parts, "\\[")
      printf "%s\t%s\t%s\n", parts[n], section, milestone
    }
  }
  ' "$board_file"
}

ish_kanban_board_get_milestone_desc() {
  local milestone="${1-}"
  local board_file

  [[ -z "$milestone" ]] && ish_tui_error --message="milestone number required"

  board_file="$(ish_packages_data_dir "ish-kanban")/board.md"
  ish_utils_exists_file --file="$board_file" || ish_tui_error --message="board not found: $board_file"
  ish_exists_executable --executable=awk || ish_tui_error --message="awk required"

  awk -v m="$milestone" '
  /^## phase [0-9]+:/ {
    num = $3
    sub(/:$/, "", num)
    if (num == m) {
      sub(/^## phase [0-9]+: */, "")
      print
      exit
    }
  }
  ' "$board_file"
}

ish_kanban_board_validate_milestone() {
  local milestone="${1-}"
  local board_file found

  [[ -z "$milestone" ]] && ish_tui_error --message="milestone number required"

  board_file="$(ish_packages_data_dir "ish-kanban")/board.md"
  ish_utils_exists_file --file="$board_file" || ish_tui_error --message="board not found: $board_file"
  ish_exists_executable --executable=awk || ish_tui_error --message="awk required"

  found=$(awk -v m="$milestone" '
  /^## phase [0-9]+:/ {
    num = $3
    sub(/:$/, "", num)
    if (num == m) { print "found"; exit }
  }
  ' "$board_file")

  [[ "$found" == "found" ]]
}
