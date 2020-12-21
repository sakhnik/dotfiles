if exists("g:loaded_plugin_lsp")
  finish
endif
let g:loaded_plugin_lsp = 1

" Initialize nvim-lsp. Not calling this will allow using YouCompleteMe,
" for example.
nmap <leader>ll :call lsp#Init()<cr>

nmap <leader>lc :call lsp#ClearSigns()<cr>
