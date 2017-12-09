if exists("loaded_errorformat_plugin")
  finish
endif
let loaded_errorformat_plugin = 1

" Add all custom errorformats to the current setting
nnoremap <leader>me :call errorformat#AddAll()<cr>
" Choose a custom errorformat to add to the current setting
nnoremap <leader>mE :call errorformat#Choose()<cr>
