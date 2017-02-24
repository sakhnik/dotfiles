" Vim syntax file"
" Language:	Boost Build v2 (BBv2)
" Maintainer:	Anatoli Sakhnik (sakhnik на gmail крапка com)
" Last change:  v1.0 2008/03/26 10:00:00

syn case match

syn match bbv2BuiltIn "\<\(glob-tree\|glob\|SHELL\|ECHO\|run\|rule\|actions\)\>"
syn match bbv2Target "^\<\([a-z\-]\+\)\>"
syn match bbv2Feature "\(<location>\|<include>\|<cflags>\|<cxxflags>\|<linkflags>\|<library>\|<define>\|<file>\|<name>\|<search>\|<variant>\|<toolset>\)"
syn match bbv2Variable "\$([^)]\+)"
syn region bbv2Comment start="#" end="$"
"syn match bbv2String '\("[^"]*"\)\|\(\'[^\']*\'\)'
syn include @Shell syntax/sh.vim
syn region bbv2Actions start="^{$" end="^}$" keepend fold contains=@Shell

hi def link bbv2BuiltIn Keyword
hi def link bbv2Comment Comment
hi def link bbv2Target Type
hi def link bbv2Feature Special
hi def link bbv2Variable Identifier
"hi def link bbv2String String
