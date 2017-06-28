#!/bin/bash

# Force dircolors, etc.
export CLICOLOR=1

# macOS.
if [[ $(uname) == "Darwin" ]]; then
  # Disable Homebrew analytics.
  export HOMEBREW_NO_ANALYTICS=1

  # Enable Homebrew Bash completion.
  if [ -f "$(brew --prefix)/etc/bash_completion" ]; then
    source "$(brew --prefix)/etc/bash_completion"
  fi

  # Powerline.
  powerline-daemon -q
  POWERLINE_BASH_CONTINUATION=1
  POWERLINE_BASH_SELECT=1
  source /usr/local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh
fi
