" Vim filetype plugin file
" Language:         Haskell
" Maintainer:       Nikolai Weibull <nikolai+work.vim@bitwi.se>
" Latest Revision:  2005-07-04

if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

let b:undo_plugin = "setl com< cms< fo<"

setlocal comments=s1fl:{-,mb:-,ex:-},:-- commentstring=--\ %s
setlocal formatoptions-=t formatoptions+=croql
setlocal expandtab
setlocal includeexpr=substitute(v:fname,'\\.','/','g').'.hs'
"set suffixesadd=.hs
setlocal path=.,d:/contrib/ghc/imports/

compiler ghc
