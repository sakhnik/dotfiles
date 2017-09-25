#!/bin/bash

set -e

dotfiles=`readlink -f $(dirname ${BASH_SOURCE[0]})`
cd "$dotfiles"

ignores=$(git status --porcelain src | perl -ne 'if (m/^?? src\/(.*)/) { print $1; if (!eof) {print "|"}}')

# Utilize GNU stow to symlink from HOME to our config files.
stow -Svt $HOME --ignore "($ignores)" src
