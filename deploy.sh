#!/bin/bash

set -e

dstdir=${1:-~}
mkdir -p "$dstdir"

dotfiles=`readlink -f $(dirname ${BASH_SOURCE[0]})`
cd "$dotfiles"

# Utilize GNU stow to symlink from HOME to our config files.
for i in *; do
	[[ -d $i ]] && stow -t "$dstdir" $i
done

zsh -df <<END
[[ ! -f "$dstdir/.zshrc" ]] && exit 1
source "$dstdir/.zshrc"
ycm-update.sh
END
