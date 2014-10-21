set nocompatible
" Let's parse $VIMINIT, which is like "source path"
if $VIMINIT =~ 'source\s\+.*'
	let f1 = substitute($VIMINIT, 'source\s\+\(.*\)', '\1', "")
	let f2 = fnamemodify(f1, ":p:h").'/runtime'
	let &runtimepath=f2.','.$VIMRUNTIME
endif
let &termencoding=&encoding
if &term == "win32"
	set termencoding=cp866
elseif &termencoding == "koi8-r"
	set termencoding=koi8-u
endif
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp1251,default
runtime $VIMRUNTIME/vimrc_example.vim
if &term == "linux"
	set t_ve+=[?81;0;112c
endif

if v:progname =~? "evim"
	finish
endif

" Make shift-insert work like in Xterm
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>

set ttyscroll=0
set nocompatible
set backspace=indent,eol,start
set nobackup
set history=50
set ruler
set showcmd
set incsearch
set wildmenu
set wildmode=longest,list
if has("win32")
	set shellpipe=2>&1\ \|\ tee
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
	syntax on
	set hlsearch
endif

if has("autocmd")

	filetype plugin indent on

	augroup vimrcEx
		au!

		" For all text files set 'textwidth' to 78 characters.
		autocmd FileType text setlocal textwidth=78 lbr
		autocmd FileType gitcommit setlocal spell

		" When editing a file, always jump to the last known cursor position.
		" Don't do it when the position is invalid or when inside an event handler
		" (happens when dropping a file on gvim).
		autocmd BufReadPost *
		    \ if line("'\"") > 0 && line("'\"") <= line("$") |
		    \   exe "normal g`\"" |
		    \ endif

	augroup END

	" Don't preserve a buffer when reading from stdin
	" This is useful for "svn diff | vim -"
	autocmd StdinReadPost * setlocal buftype=nofile

	augroup templates
		au!
		" Read source file skeletons
		autocmd BufNewFile *.*  silent! execute '0r $HOME/.vim/templates/skeleton.'.expand("<afile>:e")
	augroup END

	augroup reload_vimrc
		au!
		autocmd bufwritepost $MYVIMRC source $MYVIMRC
	augroup END

	" Substitute everything between [:VIM_EVAL:] and [:END_EVAL:]
	" with the result of expression in it
	autocmd BufNewFile *    %substitute#\[:VIM_EVAL:\]\(.\{-\}\)\[:END_EVAL:\]#\=eval(submatch(1))#ge

    " Autoclose preview window (omni completion) when leaving insert mode
    autocmd InsertLeave * if pumvisible() == 0|pclose|endif
else

	set autoindent      " always set autoindenting on

endif " has("autocmd")

set noexpandtab
set smarttab
set ignorecase smartcase
set tabstop=4
set cindent shiftwidth=4
set cinoptions=:0,=1s,g0,(0,M1,U0,u0
"set autochdir
if exists("+mouse")
	set mouse=a
endif
if has("gui_running")
	if &guifont == ''
		if has("gui_gtk2")
			set guifont=Monospace\ 11
		elseif has("x11")
			" Also for GTK 1
			set guifont=*-lucidatypewriter-medium-r-normal-*-*-180-*-*-m-*-*
		elseif has("gui_win32")
			set guifont=Courier_New:h12:cRUSSIAN
		endif
	endif
endif
set path+=../include
set listchars=tab:▸\ ,trail:·,nbsp:%
set guioptions-=T
set guioptions-=m
set mousehide
set scrolloff=3
set statusline=%<%f\ %H%M%R%=%-7.k%-14.(%l,%c%V%)\ %P
set laststatus=2
set viminfo='100,f1,<1024,h,s128
set clipboard=unnamed
set completeopt=menu,longest,preview
set tags=./tags,tags,tags;/
set timeout timeoutlen=3000 ttimeoutlen=100
let mapleader='\'
let maplocalleader=' '

nnoremap <f2> :confirm w<cr>
inoremap <f2> <c-o>:confirm w<cr>
vnoremap <f2> <esc>:confirm w<cr>gv

nnoremap <f10> :confirm qa<cr>
inoremap <f10> <c-o>:confirm qa<cr>
nnoremap <c-f8> :FencView<cr>
inoremap <c-f8> <esc>:FencView<cr>
nnoremap <f5> :GundoToggle<cr>

nnoremap <Leader>; :<c-u>ls!<Bar>sleep <c-r>=v:count1<cr><cr><cr>
vnoremap <Leader>/ <esc>/\%V
vnoremap <Leader>? <esc>?\%V
nnoremap <silent> <c-l> :<c-u>nohlsearch<cr><c-l>
nnoremap & :&&<cr>
xnoremap & :&&<cf>

" Expand %% to the directory of the current buffer
cnoremap <expr> %%  getcmdtype() == ':' ? expand('%:h').'/' : '%%'

if exists(":vnew") && exists(":diffthis")
	function! s:DiffWithSaved()
		let filetype=&ft
		diffthis
		vnew | r # | normal 1Gdd
		diffthis
		exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
	endfunction
	com! Diff call s:DiffWithSaved()
endif

if exists('+shellslash')
	set shellslash
endif

" CTRL-Tab is Next window
noremap <C-Tab> <C-W>w
inoremap <C-Tab> <C-O><C-W>w
cnoremap <C-Tab> <C-C><C-W>w
onoremap <C-Tab> <C-C><C-W>w
nnoremap <silent> \' :e $MYVIMRC<cr>

" headers shouldn't be ignored!
let g:netrw_sort_sequence='[\/]$,*,\.bak$,\.o$,\.info$,\.swp$,\.obj$'

let b:match_words = '\s*#\s*region.*$:\s*#\s*endregion'

let g:alternateExtensions_cc = "hh,h,hpp"
let g:alternateExtensions_hh = "cc,cpp,C"

let g:airline_theme='dark'
let g:airline_left_sep = ''
let g:airline_right_sep = ''
"let g:airline_linecolumn_prefix = '¶ '
let g:airline_branch_prefix = '± '   "⎇
let g:airline_paste_symbol = 'ρ'

let g:ctrlp_extensions = ['tag']
let g:ctrlp_show_hidden = 1
let g:ctrlp_use_caching = 0
let g:ctrlp_custom_ignore = {
	\ 'dir':  '\v[\/](\.git|\CBUILD[-_a-z0-9]*|sstate-cache|downloads|buildhistory|build[-_a-zA-Z]*)$'
	\ }

let g:ycm_global_ycm_extra_conf = $HOME . '/.vim/ycm_extra_conf.py'
let g:ycm_filetype_blacklist = {
	\ 'notes' : 1,
	\ 'markdown' : 1,
	\ 'text' : 1,
	\ 'unite' : 1,
	\ 'conque_term' : 1,
	\}
nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<cr>

let g:ConqueTerm_StartMessages = 0

runtime! plugin/*.vim
runtime ftplugin/man.vim

runtime bundle/pathogen/autoload/pathogen.vim
execute pathogen#infect()

set novb t_vb=    " Не бікати взагалі ніколи
"set t_ti= t_te=   " Не очищувати екран після виходу
set keymap=uk     " Завантажити українську мапу клавіш
set iminsert=0    " Встановити англійську (i_ctrl-^)
set imsearch=0
set showbreak=↪
set modeline
if has('persistent_undo')
	set undofile
	set undodir=/tmp/vim_undo-$USER
	if exists("*mkdir") && !isdirectory(&undodir)
		call mkdir(&undodir,"p")
	endif
endif

nnoremap <Leader><space> /\s\+$\\| \+\ze\t<cr>

" Ignore timestamp lines in Google Test output
let gtest_efm = '%E%f:%l:\ Failure'
let gtest_efm .= ',%Z%m'
let &efm = gtest_efm . ',' . &efm
let glib_efm = '%[%^:]%#:%[A-Z]%#:%f:%l:%m'
let &efm = glib_efm . ',' . &efm
" CMake Parser
" Call stack entries
let &efm .= ', %#%f:%l %#(%m)'
" Start of multi-line error
let &efm .= ',%E' . 'CMake Error at %f:%l (message):'
" End of multi-line error
let &efm .= ',%Z' . 'Call Stack (most recent call first):'
" Continuation is message
let &efm .= ',%C' . ' %m'

" Java completion
if has("autocmd")
  autocmd Filetype java setlocal omnifunc=javacomplete#Complete
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Unite settings
" The prefix key.
nnoremap    [unite]   <Nop>
nmap    <Leader>f [unite]

"nnoremap <silent> [unite]c  :<C-u>UniteWithCurrentDir
"        \ -buffer-name=files buffer bookmark file<CR>
"nnoremap <silent> [unite]b  :<C-u>UniteWithBufferDir
"        \ -buffer-name=files -prompt=%\  buffer bookmark file<CR>
"nnoremap <silent> [unite]r  :<C-u>Unite
"        \ -buffer-name=register register<CR>
"nnoremap <silent> [unite]o  :<C-u>Unite outline<CR>
"nnoremap <silent> [unite]f
"        \ :<C-u>Unite -buffer-name=resume resume<CR>
"nnoremap <silent> [unite]ma
"        \ :<C-u>Unite mapping<CR>
"nnoremap <silent> [unite]me
"        \ :<C-u>Unite output:message<CR>
"nnoremap  [unite]f  :<C-u>Unite source<CR>
"
"nnoremap <silent> [unite]s
"        \ :<C-u>Unite -buffer-name=files -no-split
"        \ jump_point file_point buffer_tab
"        \ file_rec:! file file/new<CR>

" Start insert.
let g:unite_enable_start_insert = 1
"let g:unite_enable_short_source_names = 1

" Like ctrlp.vim settings.
let g:unite_enable_start_insert = 1
let g:unite_winheight = 10
let g:unite_split_rule = 'botright'

" Prompt choices.
"let g:unite_prompt = '❫ '
"let g:unite_prompt = '» '

call unite#custom#source('file,file/new,buffer,file_rec',
			\ 'matchers', 'matcher_fuzzy')

autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()"{{{
  " Overwrite settings.

  nmap <buffer> <esc> <Plug>(unite_exit)
  "imap <buffer> jj      <Plug>(unite_insert_leave)
  "imap <buffer> <C-w>     <Plug>(unite_delete_backward_path)

  "imap <buffer><expr> j unite#smart_map('j', '')
  "imap <buffer> <TAB>   <Plug>(unite_select_next_line)
  "imap <buffer> <C-w>     <Plug>(unite_delete_backward_path)
  "imap <buffer> '     <Plug>(unite_quick_match_default_action)
  "nmap <buffer> '     <Plug>(unite_quick_match_default_action)
  "imap <buffer><expr> x
  "        \ unite#smart_map('x', "\<Plug>(unite_quick_match_choose_action)")
  "nmap <buffer> x     <Plug>(unite_quick_match_choose_action)
  "nmap <buffer> <C-z>     <Plug>(unite_toggle_transpose_window)
  "imap <buffer> <C-z>     <Plug>(unite_toggle_transpose_window)
  "imap <buffer> <C-y>     <Plug>(unite_narrowing_path)
  "nmap <buffer> <C-y>     <Plug>(unite_narrowing_path)
  "nmap <buffer> <C-j>     <Plug>(unite_toggle_auto_preview)
  "nmap <buffer> <C-r>     <Plug>(unite_narrowing_input_history)
  "imap <buffer> <C-r>     <Plug>(unite_narrowing_input_history)
  "nnoremap <silent><buffer><expr> l
  "        \ unite#smart_map('l', unite#do_action('default'))

  "let unite = unite#get_current_unite()
  "if unite.profile_name ==# 'search'
  "  nnoremap <silent><buffer><expr> r     unite#do_action('replace')
  "else
  "  nnoremap <silent><buffer><expr> r     unite#do_action('rename')
  "endif

  "nnoremap <silent><buffer><expr> cd     unite#do_action('lcd')
  "nnoremap <buffer><expr> S      unite#mappings#set_current_filters(
  "        \ empty(unite#mappings#get_current_filters()) ?
  "        \ ['sorter_reverse'] : [])

  "" Runs "split" action by <C-s>.
  "imap <silent><buffer><expr> <C-s>     unite#do_action('split')
endfunction"}}}

" For ack.
if executable('ack-grep')
  let g:unite_source_grep_command = 'ack-grep'
  let g:unite_source_grep_default_opts = '--no-heading --no-color -k -H'
  let g:unite_source_grep_recursive_opt = ''
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Ultisnips
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Trigger configuration.
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Syntastic
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 2  "Close location list automatically

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if &t_Co > 2 || has("gui_running")
	let g:CSApprox_attr_map = { 'bold' : 'bold', 'italic' : 'italic', 'sp' : 'fg' }
	if has("autocmd")
		if &term =~ 'rxvt-unicode.*' || &term =~ 'screen-\(256color-\)\?it'
			autocmd ColorScheme * hi Comment cterm=italic
		endif
	endif
	colors zenburn
endif

"let $PAGER=''
"vim: set noet ts=4 sw=4:
