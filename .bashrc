#!/bin/bash


# Decent prompt.
export PS1="\u@\h[\w]\\$ "

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
fi

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
