#!/bin/bash

# Source additional environment config, if present.
# shellcheck source=src/dev/null
if [ -f $HOME/.local_bash_profile ]; then
  source $HOME/.local_bash_profile
fi

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
  # shellcheck source=src/dev/null
  if [ -f "$(brew --prefix)/etc/bash_completion" ]; then
    source "$(brew --prefix)/etc/bash_completion"
  fi

  # NVM (https://github.com/creationix/nvm#installation).
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
fi
