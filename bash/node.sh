#!/bin/bash


nvm() {
  echo "...(re)installing nvm"
  URL="https://raw.githubusercontent.com/creationix/nvm/master/install.sh"
  curl -o- -s $URL | bash 1>/dev/null
}
