#!/bin/bash

set -e

dstdir=${1:-~}
mkdir -p "$dstdir"

dotfiles=`readlink -f $(dirname ${BASH_SOURCE[0]})`
cd "$dotfiles"

# Utilize GNU stow to symlink from HOME to our config files.
# Note that stow will refuse to install to the direct parent directory.
stow -t "$dstdir" src

exit
zsh -df <<END
[[ ! -f "$dstdir/.zshrc" ]] && exit 1
source "$dstdir/.zshrc"
ycm-update.sh
END
