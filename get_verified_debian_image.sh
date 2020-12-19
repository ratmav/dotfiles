#!/usr/bin/env bash

URL="https://cdimage.debian.org/debian-cd/current/amd64/iso-cd"
ISO="debian-10.7.0-amd64-netinst.iso"
CHECKSUMS="SHA512SUMS"
SIGNATURE="SHA512SUMS.sign"
KEYSERVER="keyring.debian.org"

get_iso() {
  if [ ! -f $ISO ]; then
    wget $URL/$ISO
  fi
}

get_checksums() {
  if [ ! -f $CHECKSUMS ]; then
    wget $URL/$CHECKSUMS
  fi
}

get_signature() {
  if [ ! -f $SIGNATURE ]; then
    wget $URL/$SIGNATURE
  fi
}

get() {
  if [ ! -f "$1" ]; then
    wget "$URL/$1"
  fi
}

import_key() {
  local verify_output
  verify_output="$(gpg --verify "$SIGNATURE" 2>&1 > /dev/null)"

  local keyline
  keyline="$(echo "$verify_output" | grep "using")"

  local key_id
  key_id="${keyline: -8}"

  if ! gpg --list-keys | grep -q "$key_id"; then
    gpg --keyserver "$KEYSERVER" --recv "$key_id"
  fi
}

verify_signature() {
  gpg --verify "$SIGNATURE" "$CHECKSUMS"
}

confirm_checksum() {
  local checksum
  if [[ $(uname) == "Darwin" ]]; then
    checksum=$(shasum -a 512 "$ISO")
  elif [[ $(uname) == "Linux" ]]; then
    checksum=$(sha512sum "$ISO")
  fi

  if grep -q "$checksum" "$CHECKSUMS"; then
    echo "***PASS***"
  else
    echo "***FAIL***"
  fi
}

main() {
  get $ISO
  get $CHECKSUMS
  get $SIGNATURE
  import_key
  verify_signature
  confirm_checksum
}

main "$@"
