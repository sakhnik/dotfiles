#!/bin/bash

set -e

dotfiles=`readlink -f $(dirname ${BASH_SOURCE[0]})`
cd "$dotfiles"

# Utilize GNU stow to symlink from HOME to our config files.
stow -Svt $HOME src
