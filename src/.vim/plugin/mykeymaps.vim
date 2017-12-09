
if exists("g:loaded_choose_keymap")
    finish
endif
let g:loaded_choose_keymap = 1

nmap <leader>kk :call mykeymaps#ChooseKeymap()<cr>
nmap <leader>ku :setlocal keymap=uk<cr>
