" workaround about mixed eol in a file
if did_filetype()	" filetype already set..
	finish		" ..don't do these checks
endif

"svn
if getline(1) =~ '^Index:\s\f\+\r$'
	set ft=diff
endif

"darcs
if getline(1) =~ 'Binary files \(.\(differ\)\@!\)* differ'
	set ft=diff
endif

