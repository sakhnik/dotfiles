setlocal makeprg=moonc\ %
au BufWritePost,FileWritePost <buffer> lmake

"|| lua/gdb/backend/gdb.moon	Failed to parse:
"||  [2] >>    " gdb specifics
setlocal efm=%E%f%m:,%Z\ [%l]\ %m

" vim: set et ts=2 sw=2:
