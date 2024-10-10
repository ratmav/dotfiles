#!/usr/bin/env bash

export PS1="[\u@\h \W]\\$ "

# force dircolors.
export CLICOLOR=1

# asdf
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash

# macos.
if [[ $(uname) == "Darwin" ]]; then
  # disable homebrew analytics.
  export HOMEBREW_NO_ANALYTICS=1

  # put homebrew's sbin in the path.
  export PATH="$(brew --prefix)/sbin:$PATH"

  # homebrew changed default path to /opt/homebrew,
  # and other tools (docker in particular) still
  # symlink cli binaries in /usr/local/bin by default.
  export PATH="/usr/local/bin:$PATH"
fi

# load miscellaneous environment variables if needed.
if [ -f ~/.misc_envars ]; then
    . ~/.misc_envars
fi
