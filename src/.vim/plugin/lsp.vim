if exists("g:loaded_plugin_lsp")
  finish
endif
let g:loaded_plugin_lsp = 1

" Initialize nvim-lsp. Not calling this will allow using YouCompleteMe,
" for example.
nmap <leader>ll :lua require"local.lsp".init()<cr>
nmap <leader>lc :lua require"local.lsp".clearSigns()<cr>
