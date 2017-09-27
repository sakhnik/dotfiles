#!/bin/bash

set -e

dotfiles=`readlink -f $(dirname ${BASH_SOURCE[0]})`
cd "$dotfiles"


ignores=$( \
    comm -23 <(find src -maxdepth 1 -mindepth 1 | sort) \
             <(git ls-files src | grep -oE 'src/[^/]+' | sort -u) \
    | perl -ne 's/^src\/(.*)/\1/;
                s/\n//;
                s/\./\\./g;
                print $_;
                if(!eof){print "|"}' \
)

# Utilize GNU stow to symlink from HOME to our config files.
stow -Svt $HOME --ignore "($ignores)" src
