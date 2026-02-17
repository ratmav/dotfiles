#!/usr/bin/env bash

ish_ratfiles_git_clean_help() {
  ish_utils_stream_multiline_stderr <<EOF
usage: ish ratfiles git clean [command]

commands:
  prune        prune local branches missing on remote
  worktrees    remove all worktrees except main
EOF
}

ish_ratfiles_git_clean_prune() {
  if [ $# -eq 0 ]; then
    local remote=origin
  else
    local remote=$1
  fi

  git remote prune "$remote"
  ish_tui_info --message="pruned $remote branch references."

  if git rev-parse --git-dir > /dev/null 2>&1; then
    gone_remote_branches=$(git branch -vv | grep "gone" | awk "{print \$1}")

    if [[ -z "$gone_remote_branches" ]]; then
      ish_tui_warn --message="no local branches track a gone $remote branch."
    else
      for gone_remote_branch in $gone_remote_branches; do
        echo "$gone_remote_branch" | xargs git branch -D
      done
    fi
  else
    ish_tui_error --message="not a git repository."
  fi
}

ish_ratfiles_git_clean_worktrees() {
  if git rev-parse --git-dir > /dev/null 2>&1; then
    local main_worktree=$(git rev-parse --show-toplevel)
    local worktrees=$(git worktree list --porcelain | grep "^worktree " | cut -d' ' -f2-)
    local count=0

    if [[ -z "$worktrees" ]]; then
      ish_tui_warn --message="no worktrees found."
      return
    fi

    while IFS= read -r worktree; do
      if [[ "$worktree" != "$main_worktree" ]]; then
        ish_tui_info --message="removing worktree: $worktree"
        if git worktree remove --force "$worktree" 2>/dev/null; then
          ((count++))
        else
          ish_tui_warn --message="failed to remove $worktree"
        fi
      fi
    done <<< "$worktrees"

    # clean up any broken references
    git worktree prune

    if [[ $count -eq 0 ]]; then
      ish_tui_warn --message="no worktrees removed (only main exists)."
    else
      ish_tui_info --message="removed $count worktree(s)."
    fi
  else
    ish_tui_error --message="not a git repository."
  fi
}
