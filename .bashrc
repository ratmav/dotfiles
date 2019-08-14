#!/bin/bash

export PS1="[\u@\h \W]\\$ "

# Force dircolors, etc.
export CLICOLOR=1

# tmux.
if command -v tmux > /dev/null; then
    [[ ! $TERM =~ screen ]] && [ -z $TMUX ] && [[ $- == *i* ]] && exec tmux
fi

# macOS.
if [[ $(uname) == "Darwin" ]]; then
  # Disable Homebrew analytics.
  export HOMEBREW_NO_ANALYTICS=1

  # Enable Homebrew Bash completion.
  if [ -f "$(brew --prefix)/etc/bash_completion" ]; then
    source "$(brew --prefix)/etc/bash_completion"
  fi

  # Modify the path so that Homebrew still finds pip.
  export PATH="/usr/local/opt/python/libexec/bin:$PATH"

  # Modify the path to use GNU sed.
  export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
fi

# pyenv
eval "$(pyenv init -)"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# gvm
source "$HOME/.gvm/scripts/gvm"

# load miscellaneous environment variables if needed.
if [ -f ~/.misc_envars ]; then
    . ~/.misc_envars
fi
