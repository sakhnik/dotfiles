#!/bin/bash

find -maxdepth 1 -type f -print0 | while read -d $'\0' file
do
	date=`exiftool "$file" | grep -m 1 'Date/Time Original'`
	[[ "$date" ]] || date=`exiftool "$file" | grep -m 1 '^Create Date'`
	dir=`echo "$date" | awk '{print $4;}' | sed 's/:/_/g'`
	[[ -z "$dir" ]] && continue
	echo "$file -> $dir"
	[[ -d $dir ]] || mkdir -p $dir
	mv "$file" $dir
done
