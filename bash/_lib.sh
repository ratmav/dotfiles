#!/usr/bin/env/bash

_is_kali(){
  if [[ -f /etc/issue ]]; then
    if grep -q "Kali" /etc/issue; then
      return 0
    else
      return 1
    fi
  else
    return 1
  fi
}

