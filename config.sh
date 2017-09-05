#!/bin/bash

set -e

this_dir=`dirname ${BASH_SOURCE[0]}`

cd $this_dir/src

zsh -df <<END
source ".zshrc"
ycm-update.sh
export HOME=$this_dir/src
END
