
if exists("g:loaded_choose_keymap")
    finish
endif
let g:loaded_choose_keymap = 1

function! ChooseKeymap()
    let keymaps = ['', 'uk', 'ru']
    let prompt_keymaps = []
    let index = 0
    while index < len(keymaps)
        call add(prompt_keymaps, index.'. '.keymaps[index])
        let index = index + 1
    endwhile
    let choice = inputlist(prompt_keymaps)
    if choice >= 0 && choice < len(keymaps)
		let &keymap=keymaps[choice]
    endif
	return ''
endf

nmap <leader>kk :call ChooseKeymap()<cr>
nmap <leader>ku :setlocal keymap=uk<cr>
