#!/bin/bash

echo "Updating submodules"

cd `dirname ${BASH_SOURCE[0]}`

updated=

# First pull existing changes
head_rev=$(git show-ref refs/heads/master | cut -f1 -d' ')
git pull --rebase
new_head_rev=$(git show-ref refs/heads/master | cut -f1 -d' ')

if [[ "$head_rev" == "$new_head_rev" ]]; then
	git submodule foreach git pull origin master
	LANG=C git status --porcelain | grep -q '^ [MDA]'
	if [[ $? -eq 0 ]]; then
		updated=1
		git commit -a -m 'Update vim plugins'
	fi
else
	updated=1
fi

if [[ -n "$updated" ]]; then
	git submodule update --init --recursive

	if ! git diff --quiet HEAD^.. .vim/bundle/ycm >/dev/null 2>&1; then
		echo "Compile ycm"
		pushd .vim/bundle/ycm
		./install.sh --clang-completer --system-libclang
		popd
	fi
fi

echo "Done"
