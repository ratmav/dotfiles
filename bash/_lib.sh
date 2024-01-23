#!/usr/bin/env/bash

_is_sid(){
  if [[ -f /etc/issue ]]; then
    if grep -q "Debian" /etc/issue; then
      if [[ -f /etc/apt/sources.list ]]; then
        if grep -q "sid" /etc/apt/sources.list; then
          return 0
        else
          return 1
        fi
      else
        return 1
      fi
    else
      return 1
    fi
  else
    return 1
  fi
}

