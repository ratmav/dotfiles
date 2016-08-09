#!/bin/bash

# Put the current working directory in the prompt.
export PS1="\u@\h\w$ "

# Disable Homebrew analytics.
export HOMEBREW_NO_ANALYTICS=1

# Enable Homebrew Bash completion.
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

# Link to personal scripts.
export PATH="$PATH:$HOME/Scripts/"
