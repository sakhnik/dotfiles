#!/bin/bash

tagdir=~/.tags
tagcmd="ctags -R --c++-kinds=+p --fields=+iaS --extra=+q --language-force=C++"

die()
{
    echo >&2 "$1"
    exit 1
}

mkdir -p "$tagdir" || die "Couldn't create directory for tags"
cd "$tagdir"

echo "Downloading cpp_src.tbz2"
wget -O cpp_src.tbz2 \
         http://www.vim.org/scripts/download_script.php?src_id=9178 || \
     die "Failed to download cpp_src"

echo "Uncompressing cpp_src"
tar -xjf cpp_src.tbz2 || die "Couldn't extract cpp_src"

echo "Creating tags for cpp_src"
$tagcmd cpp_src || die "Couldn't create tags of cpp_src"
mv tags cpp.tags

ace_dir=
[[ -d /usr/include/ace ]] && ace_dir=/usr/include/ace
[[ -d /usr/local/include/ace ]] && ace_dir=/usr/local/include/ace
if [[ "$ace_dir" ]]; then
    echo "Creating tags for ACE"
    $tagcmd "$ace_dir"
    mv tags ace.tags
fi
