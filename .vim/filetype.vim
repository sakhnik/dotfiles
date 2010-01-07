if did_filetype()
	finish
endif

" C++
au BufNewFile,BufRead *.ipp setf cpp
au BufNewFile,BufRead *.ly  setf lilypond

runtime! ftdetect/*.vim
