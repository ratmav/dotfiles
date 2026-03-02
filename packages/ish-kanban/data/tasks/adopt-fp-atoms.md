# adopt fp atoms

**phase:** 2

**dependencies:** none

## description

audit found 18 places where existing FP primitives are available but not used. fix the drift before building more on top of it.

## findings

### 1. inline ISH_TESTING instead of ish_packages_data_dir (9 occurrences)

`board.sh` uses `ish_packages_data_dir` correctly. these files reinvent the check inline:

- `kanban/task.sh` lines 40-44, 60-64, 97-101, 141-145, 175-179 (5x)
- `kanban/scratch.sh` lines 22-26, 53-57, 68-72 (3x)
- `kanban.sh` lines 13-17 (1x)

### 2. direct file I/O instead of ish_file_write / ish_file_append (4 occurrences)

- `kanban/task.sh:109` — `cat > "$task_file" <<EOF` instead of heredoc piped to `ish_file_write`
- `kanban/scratch.sh:60` — `echo >> file` instead of `ish_stream_stdout | ish_file_append`
- `bootstrap/posix/nix.sh:24` — `echo > file` instead of `ish_stream_stdout | ish_file_write`
- `bootstrap/posix/wezterm.sh:4-5` — `rm + cp` instead of `ish_file_read | ish_file_write`

### 3. cat heredoc instead of ish_stream_multiline_stderr (1 occurrence)

- `core/bin/ish:22` — `cat <<EOF` outputs help to stdout. every other help function uses `ish_stream_multiline_stderr` (stderr).

### 4. missing ish_exists_executable check (1 occurrence)

- `git/clean.sh:24` — uses `awk` without checking. `board.sh` always checks before awk calls.

### 5. manual while-read loop instead of ish_stream (1 occurrence)

- `git/clean.sh:49-58` — filter-then-act loop is what `ish_stream_filter` + `ish_stream_bind` do.

### 6. inconsistent ish_tui_quiet wrapping (2 occurrences)

- `kali.sh:69-70` — bare `sudo apt-get` calls. same file wraps identical calls at lines 25, 28.

## subtasks

- [ ] replace 9 inline ISH_TESTING checks with ish_packages_data_dir
- [ ] replace 4 direct file I/O calls with ish_file_write / ish_file_append
- [ ] replace cat heredoc with ish_stream_multiline_stderr in core/bin/ish
- [ ] add ish_exists_executable check for awk in git/clean.sh
- [ ] refactor while-read loop to ish_stream functions in git/clean.sh
- [ ] wrap bare apt-get calls with ish_tui_quiet in kali.sh
- [ ] verify tests still pass after each change

## deliverable

all package code uses existing FP atoms. no reinvented primitives.
