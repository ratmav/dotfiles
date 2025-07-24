#!/usr/bin/env bash

## sync local branches with remote after pruning.
git-prune-sync() {
  if [ $# -eq 0 ]; then
    local remote=origin
  else
    local remote=$1
  fi

  git remote prune "$remote"
  tui_info "pruned $remote branch references."

  if git rev-parse --git-dir > /dev/null 2>&1; then
    gone_remote_branches=$(git branch -vv | grep "gone" | awk "{print \$1}")

    if [[ -z "$gone_remote_branches" ]]; then
      tui_warn "no local branches track a gone $remote branch."
      return
    else
      for gone_remote_branch in $gone_remote_branches; do
        echo "$gone_remote_branch" | xargs git branch -D
      done
    fi
  else
    tui_error "not a git repository."
    return 1
  fi
}

## remove all worktrees except the main worktree
git-worktree-cleanup() {
  if git rev-parse --git-dir > /dev/null 2>&1; then
    local main_worktree=$(git rev-parse --show-toplevel)
    local worktrees=$(git worktree list --porcelain | grep "^worktree " | cut -d' ' -f2-)
    local count=0

    if [[ -z "$worktrees" ]]; then
      tui_warn "no worktrees found."
      return
    fi

    while IFS= read -r worktree; do
      if [[ "$worktree" != "$main_worktree" ]]; then
        tui_info "removing worktree: $worktree"
        if git worktree remove --force "$worktree" 2>/dev/null; then
          ((count++))
        else
          tui_error "...failed to remove $worktree"
        fi
      fi
    done <<< "$worktrees"

    # clean up any broken references
    git worktree prune

    if [[ $count -eq 0 ]]; then
      tui_warn "no worktrees removed (only main exists)."
    else
      tui_info "removed $count worktree(s)."
    fi
  else
    tui_error "not a git repository."
  fi
}
