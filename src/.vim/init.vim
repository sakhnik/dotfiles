" vim: set noet ts=2 sw=2:

if &term == "linux" && !has('nvim')
  set t_ve+=[?81;0;112c
endif

if has('nvim')
  runtime! python_setup.vim
endif

set fileencodings=ucs-bom,utf-8,cp1251,default
if !has('nvim')
  set nocompatible
endif
set nobackup backupdir=.
set wildmode=longest,list,full
set path+=**
set diffopt+=iwhite

if has("autocmd")

  augroup vimrcEx
    au!

    " For all text files set 'textwidth' to 78 characters.
    autocmd FileType text setlocal textwidth=78 lbr
    autocmd FileType gitcommit setlocal spell
  augroup END

  augroup misc
    au!

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif

    " Don't preserve a buffer when reading from stdin
    " This is useful for "git diff | vim -"
    autocmd StdinReadPost * setlocal buftype=nofile

    " Autoclose preview window (omni completion) when leaving insert mode
    "autocmd InsertLeave * if pumvisible() == 0|silent! pclose|endif
  augroup END

  augroup reload_vimrc
    au!
    autocmd bufwritepost $MYVIMRC source $MYVIMRC
  augroup END

  " Set custom options for specific files
  augroup custom_options
    au!
    " Evolution new message
    autocmd BufReadPost /tmp/evo*  setlocal ft=text tw=72 spell
    " Firefox extension to edit text in the entry fields
    autocmd BufReadPost /tmp/itsalltext/jira2*.txt setlocal tw=0 spell
  augroup END

endif " has("autocmd")

set ignorecase smartcase
set tabstop=4
set cindent shiftwidth=4
set cinoptions=:0,=1s,g0,(0,M1,U0,u0
set copyindent

" In many terminal emulators the mouse works just fine, thus enable it.
if exists("+mouse")
  set mouse=a

  " Make shift-insert work like in Xterm
  map <S-Insert> <MiddleMouse>
  map! <S-Insert> <MiddleMouse>
endif

if exists("+termguicolors")
  set termguicolors
  if !has('nvim')
    let &t_8f = "[38;2;%lu;%lu;%lum"
    let &t_8b = "[48;2;%lu;%lu;%lum"
  endif
endif

if !has('nvim')
  set guioptions-=T
  set guioptions-=m
  set mousehide
endif
set clipboard=unnamed
set completeopt=menu,longest,preview
set shortmess=a
let mapleader=' '
let maplocalleader=' '
"set cmdheight=2

nnoremap <leader>w :w<cr>

nnoremap & :&&<cr>
xnoremap & :&&<cr>

nmap <C-l> :redraw!<cr>

" Expand %% to the directory of the current buffer
cnoremap <expr> %%  getcmdtype() == ':' ? expand('%:h').'/' : '%%'
" Use more convenient recall from history using prefix.
" Should original scrolling be needed, use <c-u> first, or <c-f>.
cnoremap <c-n> <down>
cnoremap <c-p> <up>

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
      \ | wincmd p | diffthis
endif

nnoremap <leader>ve :split $MYVIMRC<cr>

runtime! plugin/*.vim
runtime autoload/plug.vim

let s:vimdir = fnamemodify(resolve(expand('<sfile>:p')), ':h')

call plug#begin(s:vimdir.'/plugged')
Plug 'junegunn/seoul256.vim'
Plug 'tomasr/molokai'

let s:sysname = strpart(system('uname'), 0, 4)
if s:sysname == 'MSYS'
  Plug 'ctrlpvim/ctrlp.vim'
    let g:ctrlp_user_command = {
      \ 'types': {
        \ 1: ['.git', 'cd %s && git ls-files'],
        \ 2: ['.hg', 'hg --cwd %s locate -I .'],
      \ },
      \ 'fallback': 'dir %s /-n /b /s /a-d'
    \ }
    nmap <leader>ff :CtrlP<cr>
else
  Plug 'junegunn/fzf', { 'do': './install --bin' }
  Plug 'junegunn/fzf.vim'
    nmap <leader>ff :Files<cr>
    nmap <leader>fg :GitFiles<cr>
    nmap <leader>ft :Tags<cr>
endif

if !has('nvim')
  Plug 'tpope/vim-sensible'
endif

Plug 'tpope/vim-fugitive'          " :Git
  augroup git
    au!
    autocmd BufWinEnter * if exists(":Gblame") | nmap <buffer> <leader>gb :Gblame<cr> | endif
    autocmd BufWinEnter * if exists(":Gwrite") | nmap <buffer> <leader>gw :Gwrite<cr> | endif
    autocmd BufWinEnter * if exists(":Gdiff") | nmap <buffer> <leader>gd :Gdiff<cr> | endif
    autocmd BufWinEnter * if exists(":Gvdiff") | nmap <buffer> <leader>gD :Gvdiff<cr> | endif
    autocmd BufWinEnter * if exists(":Gstatus") | nmap <buffer> <leader>gs :Gstatus<cr> | endif
    autocmd BufWinEnter * if exists(":Gcommit") | nmap <buffer> <leader>gc :Gcommit<cr> | endif
  augroup END

Plug 'gregsexton/gitv', {'on': 'Gitv'}

Plug 'tpope/vim-eunuch'            " :SudoWrite
Plug 'tpope/vim-repeat'            " Repeat mapping with .
Plug 'tpope/vim-sleuth'            " Set buffer options euristically
Plug 'tpope/vim-unimpaired'        " ]q, ]a etc
Plug 'tpope/vim-surround'          " Movements s', s(
Plug 'tpope/vim-vinegar'
Plug 'bronson/vim-visual-star-search'
Plug 'vim-scripts/dbext.vim', { 'on': 'Dbext' }
Plug 'raimondi/delimitmate'
Plug 'drmikehenry/vim-fontsize'
Plug 'wellle/targets.vim'
"Plug 'sheerun/vim-polyglot'
Plug 'vim-jp/vim-cpp'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
  let g:vim_markdown_folding_disabled = 1
  let g:vim_markdown_frontmatter = 1
  let g:vim_markdown_no_default_key_mappings = 1

Plug 'lyuts/vim-rtags'
  let g:rtagsUseLocationList = 0

Plug 'majutsushi/tagbar'
  nnoremap <leader>tb :TagbarToggle<cr>

Plug 'Kris2k/A.vim'
  let g:alternateExtensions_cc = "hh,h,hpp"
  let g:alternateExtensions_hh = "cc"
  let g:alternateExtensions_hxx = "cxx"
  let g:alternateExtensions_cxx = "hxx,h"

Plug 'simnalamburt/vim-mundo'
  nnoremap <leader>uu :GundoToggle<cr>

Plug 'bling/vim-airline'
  let g:airline_theme='dark'
  let g:airline_left_sep = ''
  let g:airline_right_sep = ''
  if !exists('g:airline_symbols')
    let g:airline_symbols = {}
  endif
  let g:airline_symbols.branch = '⎇ '   "±
  let g:airline_symbols.paste = 'ρ'
  "let g:airline_symbols.linenr = '¶ '
  let g:airline#extensions#whitespace#mixed_indent_algo = 2
  let g:airline#extensions#tabline#enabled = 0

Plug 'neomake/neomake'
  let g:neomake_open_list = 2
  let g:neomake_serialize = 1
  let g:neomake_serialize_abort_on_error = 1

  nnoremap <leader>nm :Neomake!<cr>
  nnoremap <leader>nn :Neomake<cr>

Plug 'nathanaelkane/vim-indent-guides', { 'on': ['IndentGuidesToggle', 'IndentGuidesEnable'] }
  let g:indent_guides_guide_size = 1
  let g:indent_guides_color_change_percent = 20
  nmap <leader>ig :IndentGuidesToggle<cr>

Plug 'mhinz/vim-grepper'
  nnoremap <leader>gg :Grepper -tool git<cr>
  nnoremap <leader>ga :Grepper -tool ag<cr>
  nnoremap <leader>gh :Grepper -tool hg<cr>
  let g:grepper = {
    \ 'tools': ['hg', 'git', 'grep'],
    \ 'hg': {
    \   'grepprg':    'hg grep -n -r "reverse(::.)"',
    \   'grepformat': '%f:%\\d%\\+:%l:%m',
    \   'escape':     '\+*^$()[]',
    \ }}

Plug 'tenfyzhong/CompleteParameter.vim'

Plug 'ledger/vim-ledger'
  let g:ledger_extra_options = '--pedantic --explicit --check-payees --price-db prices.db'
  let g:ledger_align_at = 45
  let g:ledger_default_commodity = '₴'
  let g:ledger_commodity_before = 0
  let g:ledger_commodity_sep = ' '
  let g:ledger_fold_blanks = 1

Plug 'sakhnik/nvim-gdb'

  "nnoremap <leader>dd :GdbStart gdb -q -f a.out

call plug#end()


"""""""""""""""""""""""""""""""""""""""""""""""""""
" YouCompleteMe stuff
" The plugin should be delpoyed by the script ycm-update.sh

if isdirectory(s:vimdir . '/YouCompleteMe')
  let g:ycm_global_ycm_extra_conf = s:vimdir . '/ycm_extra_conf.py'
  let g:ycm_filetype_whitelist = {
    \ 'cpp' : 1,
    \ 'python' : 1,
    \}
  let g:ycm_confirm_extra_conf = 0
  let g:ycm_collect_identifiers_from_tags_files = 1 " Let YCM read tags from Ctags file
  let g:ycm_seed_identifiers_with_syntax = 1 " Completion for programming language's keyword
  let g:ycm_complete_in_comments = 1 " Completion in comments
  let g:ycm_complete_in_strings = 1 " Completion in string

  " If there's preinstalled version, integrated with system libraries, prefer it
  exe 'set rtp+='.s:vimdir.'/YouCompleteMe'
  exe 'source '.s:vimdir.'/YouCompleteMe/plugin/youcompleteme.vim'

  autocmd! User YouCompleteMe call youcompleteme#Enable()

  nnoremap <leader>yj :YcmCompleter GoToDefinitionElseDeclaration<cr>
  nnoremap <leader>yd :YcmCompleter GetDoc<cr>
  nnoremap <leader>yf :YcmCompleter FixIt<cr>
  nnoremap <leader>yy :YcmDiags<cr>
endif   " YouCompleteMe

"""""""""""""""""""""""""""""""""""""""""""""""""

set novb t_vb=    " Не бікати взагалі ніколи
"set t_ti= t_te=   " Не очищувати екран після виходу
set showbreak=\\  "↪
set modeline
if has('persistent_undo')
  set undofile
  set undodir=/tmp/vim_undo-$USER
  if !isdirectory(&undodir)
    if exists("*mkdir")
      call mkdir(&undodir, "p", 0700)
    else
      set undodir=.
    endif
  endif
endif
" Forget about ex mode
map Q <nop>
" Don't use Ex mode, use Q for formatting
"map Q gq

" Find tailing white spaces
nnoremap <Leader><space> /\s\+$\\| \+\ze\t<cr>

" Doxygen parser
let &efm = &efm . ',%f:%l\ %m'

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


" NetRW
let g:netrw_liststyle = 3

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if &t_Co == 256 || has("gui_running")
  if has("autocmd")
    augroup colors
      au!
      autocmd ColorScheme * hi Comment cterm=italic
    augroup END
  endif
  colors zenburn
  hi Comment cterm=italic
endif

"vim: set et ts=4 sw=4:
