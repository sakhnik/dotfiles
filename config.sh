#!/bin/bash

set -e

export this_dir=$(dirname `readlink -f ${BASH_SOURCE[0]}`)
cd $this_dir

export HOME=$this_dir/src

zsh -df -c "source src/.zshrc"
./src/.bin/ycm-update.sh || echo "Failed to install YCM"

vim=vim
if which nvim 2>/dev/null; then
    vim=nvim
fi

$vim +PlugInstall +qa
