#!/bin/bash

echo "Updating submodules"

cd `dirname ${BASH_SOURCE[0]}`
git submodule foreach git pull origin master
LANG=C git status | grep -q 'nothing to commit' && exit 0
git commit -a -m 'Update vim plugins'
git submodule update --init --recursive

echo "Compile vimproc"
pushd .vim/bundle/vimproc
make
popd

echo "Compile ycm"
pushd .vim/bundle/ycm
./install --clang-completer --system-libclang
popd

echo "Done"
