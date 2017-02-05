nmap <buffer> <leader>ld :call ledger#transaction_date_set('.'), "auxiliary")<cr>
nmap <buffer> <leader>la :LedgerAlign<cr>
nmap <buffer> <leader>lh :call ledger#align_amount_at_cursor()<cr>
inoremap <buffer> <silent> <Tab> <C-r>=ledger#autocomplete_and_align()<cr>
vnoremap <buffer> <silent> <Tab> :LedgerAlign<cr>
