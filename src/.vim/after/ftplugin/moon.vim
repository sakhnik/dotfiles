" Compile moonscript files to Lua automatically, unless it's busted test
" specs. Busted supports moonscript natively.
setlocal makeprg=moonc\ %
au BufWritePost,FileWritePost <buffer> if match(bufname('%'), '_spec\.moon$') == -1 | lmake | endif

"|| lua/gdb/backend/gdb.moon	Failed to parse:
"||  [2] >>    " gdb specifics
setlocal efm=%E%f%m:,%Z\ [%l]\ %m

" vim: set et ts=2 sw=2:
