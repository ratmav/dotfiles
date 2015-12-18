#! /bin/bash

# Uninstalls all gems for current Ruby version, re-installs Bundler.
# NOTE: Requires rbenv.

for i in `gem list --no-versions`; do gem uninstall -aIx $i; done && gem install bundler && rbenv rehash
