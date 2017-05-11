#!/bin/bash

# Colored terminal output.
export CLICOLOR=1

# Decent prompt.
USER="\[\033[38;5;43m\]\u\[$(tput sgr0)\]"
HOST="\[\033[38;5;35m\]@\h\[$(tput sgr0)\]"
DIR="\[\033[38;5;65m\][\w]:\[$(tput sgr0)\]"
SPACE="\[\033[38;5;15m\] \[$(tput sgr0)\]"
export PS1="$USER$HOST$DIR$SPACE"

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
