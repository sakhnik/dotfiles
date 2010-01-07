" local syntax file - set colors on a per-machine basis:
" vim: tw=0 ts=4 sw=4
" Vim color file
" Maintainer:	Ron Aaron <ron@ronware.org>
" Last Change:	2003 May 02

hi clear
set background=dark
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "incognito"

"
hi Comment		ctermfg=darkcyan 			guifg=darkcyan
hi Structure	ctermfg=green cterm=bold	guifg=#00c000 gui=bold
hi Macro		ctermfg=blue cterm=bold		guifg=#0000c0 gui=bold
hi Directory	ctermfg=magenta				guifg=#ff00a0
hi Include		ctermfg=blue cterm=bold		guifg=#0000c0 gui=bold
hi PreCondit	ctermfg=blue cterm=bold		guifg=#0000c0 gui=bold
hi Number		ctermfg=magenta				guifg=#ff00a0
hi Type			ctermfg=green				guifg=#00d000
hi Statement	ctermfg=yellow cterm=bold	guifg=#ffff00 gui=bold
hi String		ctermfg=magenta				guifg=#ff00a0
hi Normal		guifg=#ffffff				guibg=#000000
"
hi clear Visual
hi Visual		guibg=darkblue guifg=gray
hi Visual		ctermbg=darkblue ctermfg=gray
"
hi Pmenu		ctermbg=darkblue guibg=darkblue
hi PmenuSel		ctermbg=magenta guibg=magenta
hi PmenuThumb	ctermfg=blue guifg=blue
