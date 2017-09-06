#!/bin/bash

set -e

export this_dir=$(dirname `readlink -f ${BASH_SOURCE[0]}`)
cd $this_dir

zsh -df <<END
export HOME=$this_dir/src
source "src/.zshrc"
ycm-update.sh
vim +PlugInstall +qa
END
