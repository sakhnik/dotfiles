#!/bin/bash

set -e

dotfiles=`readlink -f $(dirname ${BASH_SOURCE[0]})`

cd

for i in $dotfiles/.*; do
	if [[ $i =~ /\.(|\.|git|gitignore|gitmodules)$ ]]; then
		continue
	fi
	ln -sf $i
done

mkdir -p ~/.config
unlink ~/.config/nvim || true
ln -sf $dotfiles/.vim ~/.config/nvim
