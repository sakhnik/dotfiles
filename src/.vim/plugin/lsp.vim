if exists("g:loaded_plugin_lsp")
  finish
endif
let g:loaded_plugin_lsp = 1

nmap <leader>l :call lsp#EnableLocal()<cr>
