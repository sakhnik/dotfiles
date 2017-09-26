#!/bin/bash

set -e

export this_dir=$(dirname `readlink -f ${BASH_SOURCE[0]}`)
cd $this_dir

export HOME=$this_dir/src

zsh -df -c "source src/.zshrc"
./src/.bin/ycm-update.sh

vim=vim
[[ -x /usr/bin/nvim ]] && vim=nvim

$vim +PlugInstall +qa
