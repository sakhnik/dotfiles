#!/bin/bash

set -e

vimdir=`dirname ${BASH_SOURCE[0]}`/../.vim

# Check that all directories in includes.txt are still present
# If something is missing, high chance that stdc++ has been updated.
includes=$vimdir/includes.txt
if [[ -f $includes ]]; then
	for i in `cat $includes`; do
		[[ -d $i ]] || exit 1
	done
fi

# Check that system libraries haven't changed for ycmd
library=$vimdir/YouCompleteMe/third_party/ycmd/ycm_core.so
if [[ -f $library ]]; then
	ldd $library | grep -q 'not found' && exit 2 || true
fi
