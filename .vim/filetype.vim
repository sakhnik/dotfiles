if did_filetype()
	finish
endif

" C++
au BufNewFile,BufRead *.ipp setf cpp
" Vala
autocmd BufRead *.vala,*.vapi set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
au BufRead,BufNewFile *.vala,*.vapi setfiletype vala

runtime! ftdetect/*.vim
