"""""""""""""""""""""""""""""""""""""""""""""""""""
" YouCompleteMe stuff
" The plugin should be delpoyed by the script ycm-update.sh

if exists("g:loaded_plugin_ycm")
    finish
endif
let g:loaded_plugin_ycm = 1

let s:ycmdir = g:vimdir . '/YouCompleteMe'
if !isdirectory(s:ycmdir)
  let s:ycmdir = '/tmp/YouCompleteMe'
  if !isdirectory(s:ycmdir)
    finish
  endif
endif

augroup YCM
  au!
  au FileType cpp,python setlocal signcolumn=yes
augroup END

let g:ycm_filetype_whitelist = {
  \ 'cpp' : 1,
  \ 'python' : 1,
  \}
"let g:ycm_collect_identifiers_from_tags_files = 1 " Let YCM read tags from Ctags file
"let g:ycm_seed_identifiers_with_syntax = 1 " Completion for programming language's keyword
let g:ycm_complete_in_comments = 1 " Completion in comments
let g:ycm_complete_in_strings = 1 " Completion in string
let g:ycm_always_populate_location_list = 1
let g:ycm_use_clangd = 0

" If there's preinstalled version, integrated with system libraries, prefer it
exe 'set rtp+='.s:ycmdir
exe 'source '.s:ycmdir.'/plugin/youcompleteme.vim'

nnoremap <leader>yj :YcmCompleter GoToDefinitionElseDeclaration<cr>
nnoremap <leader>yd :YcmCompleter GetDoc<cr>
nnoremap <leader>yf :YcmCompleter FixIt<cr>
nnoremap <leader>yy :YcmDiags<cr>
