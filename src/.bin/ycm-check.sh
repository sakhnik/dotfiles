#!/bin/bash

set -e

vimdir=$(cd `dirname ${BASH_SOURCE[0]}`/../.vim; pwd)

# Check that system libraries haven't changed for ycmd
library=$vimdir/YouCompleteMe/third_party/ycmd/ycm_core.so
if [[ -f $library ]]; then
	ldd $library | grep -q 'not found' && exit 2 || true
fi
