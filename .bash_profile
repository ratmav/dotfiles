#!/bin/bash

# Start tmux if installed, screen term not in use,
# tmux not already running, and interactive shell.
if command -v tmux>/dev/null; then
  [[ ! $TERM =~ screen ]] && [ -z $TMUX ] && [[ $- == *i* ]] && exec tmux
fi

# Put the current working directory in the prompt.
export PS1="\u@\h\w$ "

if [[ $(uname) == "Darwin" ]]; then
  # Disable Homebrew analytics.
  export HOMEBREW_NO_ANALYTICS=1

  # Enable Homebrew Bash completion.
  # shellcheck source=src/dev/null
  if [ -f "$(brew --prefix)/etc/bash_completion" ]; then
    source "$(brew --prefix)/etc/bash_completion"
  fi
fi

# Link to personal scripts.
export PATH="$PATH:$HOME/Scripts/"

# Source additional environment config, if present.
# shellcheck source=src/dev/null
if [ -f ~/.local_bash_profile ]; then
  source ~/.local_bash_profile
fi

# NVM (https://github.com/creationix/nvm#installation).
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
