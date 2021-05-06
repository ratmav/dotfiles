#!/usr/bin/env bash

export PS1="[\u@\h \W]\\$ "

# force dircolors.
export CLICOLOR=1

# asdf
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash

# rust
source "$HOME/.cargo/env"

alias asdf-go-reshim='asdf reshim golang && export GOV=$(asdf current golang | sed  '\''s/ *(set by .*)//g'\'') && export GOROOT="$ASDFINSTALLS/golang/$GOV/go/"'

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

  # use homebrew's tcl-tk first.
  export PATH="/usr/local/opt/tcl-tk/bin:$PATH"
  export LDFLAGS="-L/usr/local/opt/tcl-tk/lib"
  export CPPFLAGS="-I/usr/local/opt/tcl-tk/include"
  export PKG_CONFIG_PATH="/usr/local/opt/tcl-tk/lib/pkgconfig"

  # use homebrew's libffi first.
  export LDFLAGS="-L/usr/local/opt/libffi/lib"
  export CPPFLAGS="-I/usr/local/opt/libffi/include"
  export PKG_CONFIG_PATH="/usr/local/opt/libffi/lib/pkgconfig"

  # use hombrew's guile first.
  export GUILE_LOAD_PATH="/usr/local/share/guile/site/3.0"
  export GUILE_LOAD_COMPILED_PATH="/usr/local/lib/guile/3.0/site-ccache"
  export GUILE_SYSTEM_EXTENSIONS_PATH="/usr/local/lib/guile/3.0/extensions"

  # set lang for python.
  export LANG="en_US.UTF-8"
fi

# load miscellaneous environment variables if needed.
if [ -f ~/.misc_envars ]; then
    . ~/.misc_envars
fi
. "$HOME/.cargo/env"
