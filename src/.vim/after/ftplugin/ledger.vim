nmap <buffer> <leader>ld :call ledger#transaction_date_set('.'), "auxiliary")<cr>
nmap <buffer> <leader>la :LedgerAlign<cr>
nmap <buffer> <leader>lh :call ledger#align_amount_at_cursor()<cr>
inoremap <buffer> <silent> <Tab> <C-r>=ledger#autocomplete_and_align()<cr>
vnoremap <buffer> <silent> <Tab> :LedgerAlign<cr>
inoremap <buffer> <silent> <c-l> <esc>:call ledger#entry()<cr>

"Evaluate arithmetic expressions
nmap <buffer> <silent> <leader>le :set opfunc=LedgerEvaluateExpr<CR>g@
vmap <buffer> <silent> <leader>le :<C-U>call LedgerEvaluateExpr(visualmode(), 1)<CR>

function! LedgerEvaluateExpr(type, ...)
	let sel_save = &selection
	let &selection = "inclusive"
	let reg_save = @@

	if a:0  " Invoked from Visual mode, use gv command.
		silent exe "normal! y"
	elseif a:type == 'line'
		silent exe "normal! '[V']y"
	else
		silent exe "normal! `[v`]y"
	endif

	silent exe "normal! gvc=\""

	let &selection = sel_save
	let @@ = reg_save
endfunction

noremap <buffer> <silent> <leader>ll :call ledger#transaction_state_toggle(line('.'), ' *')<CR>

setlocal completeopt-=noinsert,noselect
