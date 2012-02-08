" Vim filetype plugin file
" Language:	xml
" Maintainer:	Dan Sharp <dwsharp at hotmail dot com>
" Last Changed: 2003 Sep 29
" URL:		http://mywebpage.netscape.com/sharppeople/vim/ftplugin

if exists("b:did_ftplugin") | finish | endif
let b:did_ftplugin = 1

" Make sure the continuation lines below do not cause problems in
" compatibility mode.
let s:save_cpo = &cpo
set cpo-=C

if !filereadable("Makefile")
    set makeprg=xelatex\ %
endif

" Restore the saved compatibility options.
let &cpo = s:save_cpo
