#!/bin/bash

export PS1="[\u@\h \W]\\$ "

# force dircolors.
export CLICOLOR=1

# tmux.
if command -v tmux > /dev/null; then
    [[ ! $TERM =~ screen ]] && [ -z $TMUX ] && [[ $- == *i* ]] && exec tmux
fi

# macos.
if [[ $(uname) == "Darwin" ]]; then
  # disable homebrew analytics.
  export HOMEBREW_NO_ANALYTICS=1

  # enable brew bash completion.
  if [ -f "$(brew --prefix)/etc/bash_completion" ]; then
    source "$(brew --prefix)/etc/bash_completion"
  fi

  # put homebrew's sbin in the path.
  export PATH="/usr/local/sbin:$PATH"
fi

# load miscellaneous environment variables if needed.
if [ -f ~/.misc_envars ]; then
    . ~/.misc_envars
fi
