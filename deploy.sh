#!/bin/bash

set -e

dstdir=${1:-~}

dotfiles=`readlink -f $(dirname ${BASH_SOURCE[0]})`
cd "$dotfiles"

# Utilize GNU stow to symlink from HOME to our config files.
for i in *; do
	[[ -d $i ]] && stow -t "$dstdir" $i
done
