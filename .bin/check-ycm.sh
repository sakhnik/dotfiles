#!/bin/bash

set -e

# Check that all directories in includes.txt are still present
# If something is missing, high chance that stdc++ has been updated.
for i in `cat ~/.vim/includes.txt`; do
    [[ -d $i ]] || exit 1
done

# Check that system libraries haven't changed for ycmd
ldd ~/.vim/YouCompleteMe/third_party/ycmd/ycm_core.so | grep -q 'not found' || exit 2
