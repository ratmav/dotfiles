#! /bin/bash

# Cleans Vi/Vim buffer files recursively from current directory.

find ./ -type f -name "\.*sw[klmnop]" -delete
