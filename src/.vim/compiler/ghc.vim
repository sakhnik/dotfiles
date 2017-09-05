if exists("current_compiler")
    finish
endif
let current_compiler = "ghc"

let s:cpo_save = &cpo
set cpo&vim

"I can't make this work because of dependencies.  
"Maybe you will; i just use make
"setlocal makeprg=ghc\ %
setlocal errorformat=%A%f:%l:%c:\ %m,%A%f:%l:%c:,%C%\\s%m,%Z

let &cpo = s:cpo_save
unlet s:cpo_save
