#!/usr/bin/env bash
# shellcheck disable=SC1091

# shell configuration

export PS1="[\u@\h \W]\\$ "

## force dircolors.

export CLICOLOR=1

## asdf

source "$HOME"/.asdf/asdf.sh
source "$HOME"/.asdf/completions/asdf.bash

## docker

export DOCKER_CLI_HINTS=false

## macos.

if [[ $(uname) == "Darwin" ]]; then
  # disable homebrew analytics.
  export HOMEBREW_NO_ANALYTICS=1

  # put homebrew's sbin in the path.
  PATH="$(brew --prefix)/sbin:$PATH"

  # git bash completion
  source "$(brew --prefix)"/etc/bash_completion.d/git-completion.bash

  # homebrew changed default path to /opt/homebrew,
  # and other tools (docker in particular) still
  # symlink cli binaries in /usr/local/bin by default.
  PATH="/usr/local/bin:$PATH"

  # TeX binaries for pandoc.
  PATH="/Library/TeX/Root/bin/universal-darwin/:$PATH"
fi

## final path export.

export PATH

# utility functions

## attempt to find parent branch.
git-guess-parent() {
  # Check if a branch name is provided, otherwise use current branch
  if [ $# -eq 0 ]; then
    local branch=$(git rev-parse --abbrev-ref HEAD)
  else
    local branch=$1
  fi

  if [ "$(type -P git)" ]; then
    if git rev-parse --git-dir > /dev/null 2>&1; then
      if git show-ref --verify --quiet refs/heads/$branch; then
        # attempts to find the parent branch by:
        # 1. using show-branch to show relationship between branches
        # 2. filtering to branches that contain commits that the current branch has
        # 3. removing the current branch from consideration
        # 4. taking the topmost result (most likely to be the parent)
        # 5. extracting just the branch name from the result
        local parent_branch=$(git show-branch |
                             grep '*' |
                             grep -v "$branch" |
                             head -n1 |
                             sed 's/.*\[\(.*\)\].*/\1/' |
                             sed 's/[\^~].*//')

        if [[ -z "$parent_branch" ]]; then
          echo "Could not determine parent branch for '$branch'."
        else
          echo "$parent_branch"
        fi
      else
        echo "Branch '$branch' does not exist."
      fi
    else
      echo "Not a git repository."
    fi
  else
    echo "'git' command not available. Check your installation."
  fi
}

## sync local branches with remote after pruning.
git-prune-sync() {
  if [ $# -eq 0 ]; then
    local remote=origin
  else
    local remote=$1
  fi

  if [ "$(type -P git)" ]; then
    git remote prune "$remote"
    echo "pruned $remote branch references."

    if git rev-parse --git-dir > /dev/null 2>&1; then
      gone_remote_branches=$(git branch -vv | grep "gone" | awk "{print \$1}")

      if [[ -z "$gone_remote_branches" ]]; then
        echo "no local branches track a gone $remote branch."
      else
        for gone_remote_branch in $gone_remote_branches; do
          echo "$gone_remote_branch" | xargs git branch -D
        done
      fi
    else
      echo "not a git repository."
    fi
  else
    echo "'git' command not available. check your installation."
  fi
}

## Makefile tab completion.

_make_completion() {
    local cur prev targets

    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    # Parse Makefile targets
    targets=$(make -qp | awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$)/ {split($1,A,/ /);print A[1]}' | sort -u)

    COMPREPLY=( $(compgen -W "${targets}" -- ${cur}) )
    return 0
}
complete -F _make_completion make

# rust

if [ -f "$HOME"/.cargo/env ]; then
  source "$HOME"/.cargo/env
fi

# host-specific configuration

if [ -f "$HOME"/.this_machine ]; then
  source "$HOME"/.this_machine
fi
