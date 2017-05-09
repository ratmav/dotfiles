#!/bin/bash

# Source additional environment config, if present.
# shellcheck source=src/dev/null
if [ -f $HOME/.local_bash_profile ]; then
  source $HOME/.local_bash_profile
fi

# Colored terminal output.
export CLICOLOR=1

# Decent prompt.
export PS1="\[\033[38;5;11m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\]@\h:\[$(tput sgr0)\]\[\033[38;5;6m\][\w]:\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]"

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

# Link to personal scripts.
export PATH="$PATH:$HOME/Scripts/"
