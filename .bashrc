#!/usr/bin/env bash
# shellcheck disable=SC1091

export PS1="[\u@\h \W]\\$ "

# force dircolors.
export CLICOLOR=1

# asdf
source "$HOME"/.asdf/asdf.sh
source "$HOME"/.asdf/completions/asdf.bash

# macos.
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
fi

export PATH

# load host-specific shell configuration.
if [ -f "$HOME"/.this_machine ]; then
    source "$HOME"/.this_machine
fi
