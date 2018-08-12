#!/bin/bash

# This script installs YouCompleteMe for vim removing all the junk.
# Hence, installation is 10 MB instead of 400.

set -e

vimdir=$(cd `dirname ${BASH_SOURCE[0]}`/../.vim; pwd)

# Arrange a temporary directory
workdir=`mktemp -d /tmp/ycm.XXXXXXX`
trap 'rm -rf $workdir' EXIT

# Clone the source code of the plugin
cd $workdir
git clone --depth 1 https://github.com/Valloric/YouCompleteMe
cd YouCompleteMe
git submodule update --init --recommend-shallow --jobs 2

# Skip unnecessary modules (C#, go, rust)
(
    cd third_party/ycmd
    for s in OmniSharpServer gocode godef racerd; do
        git submodule deinit third_party/$s
        git rm third_party/$s
    done

)

# Clone the rest of submodules
git submodule update --init --recursive --recommend-shallow --jobs 8
find -name '.git*' -prune -exec rm -rf {} \;

# Build completion of C++ code
python2 install.py --clang-completer --system-boost --system-libclang

# Remove source code
rm -rf third_party/ycmd/cpp
rm -rf third_party/ycmd/clang_includes
# Remove the library, which has been copied from the system
rm -rf third_party/ycmd/libclang*
# Remove tests and docs
find third_party -type d -name tests -prune -exec rm -rf {} \;
find third_party -type d -name docs -prune -exec rm -rf {} \;

# Deploy the plugin into vim directory
cd ..
rsync -raP --delete YouCompleteMe $vimdir/

# Update vim help tags
vim="vim -es"
if which nvim >/dev/null 2>&1; then
    vim="nvim -es --headless"
fi

$vim -es +"helptags $vimdir/YouCompleteMe/doc" +qa

echo "SUCCESS"
