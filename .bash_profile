#!/bin/bash

# Put the current working directory in the prompt.
export PS1="\u@\h\w$ "

# Disable Homebrew analytics.
export HOMEBREW_NO_ANALYTICS=1

# Enable Homebrew Bash completion.
# shellcheck source=src/dev/null
if [ -f "$(brew --prefix)/etc/bash_completion" ]; then
  source "$(brew --prefix)/etc/bash_completion"
fi

# Link to personal scripts.
export PATH="$PATH:$HOME/Scripts/"

# Source additional environment config, if present.
# shellcheck source=src/dev/null
if [ -f ~/.local_bash_profile ]; then
  source ~/.local_bash_profile
fi
