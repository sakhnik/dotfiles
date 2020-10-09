" vim: set et ts=2 sw=2:

if &compatible   " Beware of side effects, the check is necessary before set nocp
  set nocompatible
endif
set fileencodings=ucs-bom,utf-8,cp1251,default
set nobackup backupdir=.
set wildmode=longest,list,full
set diffopt+=iwhite
set ignorecase smartcase
set tabstop=4
set cindent shiftwidth=4
set cinoptions=:0,=1s,g0,(0,M1,U0,u0
set copyindent
set expandtab
set hidden
set mouse=a
set termguicolors
set incsearch
set completeopt=menu,preview
set shortmess=ac
let mapleader=' '
let maplocalleader=' '
"set cmdheight=2
set lazyredraw
set laststatus=1

nnoremap <leader>w :w<cr>
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
  command! DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
      \ | wincmd p | diffthis
endif

let g:vimdir = fnamemodify(resolve(expand('<sfile>:p')), ':h')

function! PackInit() abort
  let s:minpac_dir = g:vimdir . '/pack/minpac/opt/minpac'
  if empty(glob(s:minpac_dir))
    exe 'silent !git clone https://github.com/k-takata/minpac.git ' . s:minpac_dir
  endif

  packadd minpac
  call minpac#init()
  " minpac must have {'type': 'opt'} so that it can be loaded with `packadd`.
  call minpac#add('k-takata/minpac', {'type': 'opt'})
  call minpac#add('junegunn/fzf')
  call minpac#add('junegunn/fzf.vim')
  call minpac#add('tpope/vim-fugitive')
  call minpac#add('tpope/vim-eunuch')            " :SudoWrite
  call minpac#add('tpope/vim-repeat')            " Repeat mapping with .
  call minpac#add('tpope/vim-sleuth' )           " Set buffer options euristically
  call minpac#add('tpope/vim-unimpaired')        " ]q, ]a etc
  call minpac#add('tpope/vim-surround')          " Movements s', s(
  call minpac#add('tpope/vim-vinegar')
  call minpac#add('bronson/vim-visual-star-search')
  call minpac#add('raimondi/delimitmate')
  call minpac#add('wellle/targets.vim')
  call minpac#add('https://github.com/sheerun/vim-polyglot')
  call minpac#add('mh21/errormarker.vim')
  call minpac#add('sirtaj/vim-openscad')
  call minpac#add('plasticboy/vim-markdown')
  call minpac#add('andymass/vim-matchup')
  call minpac#add('majutsushi/tagbar')
  call minpac#add('Kris2k/A.vim')
  call minpac#add('mhinz/vim-grepper')
  call minpac#add('ledger/vim-ledger')
  call minpac#add('sakhnik/nvim-gdb')
  call minpac#add('w0rp/ale')
  call minpac#add('natebosch/vim-lsc')
endfunction

command! PackUpdate call PackInit() | call minpac#update()
command! PackClean  call PackInit() | call minpac#clean()
command! PackStatus call PackInit() | call minpac#status()

nmap <leader>ff :Files<cr>
nmap <leader>fg :GitFiles<cr>
nmap <leader>ft :Tags<cr>

augroup git
  au!
  autocmd BufWinEnter * if exists(":Gblame") | nmap <buffer> <leader>gb :Gblame<cr>| endif
  autocmd BufWinEnter * if exists(":Gwrite") | nmap <buffer> <leader>gw :Gwrite<cr>| endif
  autocmd BufWinEnter * if exists(":Gdiff") | nmap <buffer> <leader>gd :Gdiff<cr>| endif
  autocmd BufWinEnter * if exists(":Gvdiff") | nmap <buffer> <leader>gD :Gvdiff<cr>| endif
  autocmd BufWinEnter * if exists(":Gstatus") | nmap <buffer> <leader>gs :Gstatus<cr>| endif
  autocmd BufWinEnter * if exists(":Gcommit") | nmap <buffer> <leader>gc :Gcommit<cr>| endif
  autocmd BufWinEnter * if exists(":Gpush") | nmap <buffer> <leader>gp :Gpush<cr>| endif
augroup END

let g:targets_aiAI = 'aIAi'
let g:polyglot_disabled = []
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_no_default_key_mappings = 1

let g:matchup_matchparen_status_offscreen = 0

nnoremap <leader>tb :TagbarToggle<cr>

let g:alternateExtensions_cc = "hh,h,hpp"
let g:alternateExtensions_hh = "cc"
let g:alternateExtensions_hxx = "cxx"
let g:alternateExtensions_cxx = "hxx,h"

nnoremap <leader>gG :Grepper -tool git<cr>
nnoremap <leader>ga :Grepper -tool ag<cr>
nnoremap <leader>gg :Grepper -tool rg<cr>
let g:grepper = {
  \ 'tools': ['rg', 'git', 'grep'],
  \ }

let g:ledger_bin = 'ledger'
let g:ledger_date_format = '%Y-%m-%d'
let g:ledger_extra_options = '--pedantic --explicit --price-db prices.db --date-format '.g:ledger_date_format
let g:ledger_align_at = 45
let g:ledger_default_commodity = '₴'
let g:ledger_commodity_before = 0
let g:ledger_commodity_sep = ' '
let g:ledger_fold_blanks = 1

let g:ale_virtualtext_cursor = 1
let g:ale_linters = {'cpp': []}  "Disable ALE linters for c++, YCM will do the job.

let g:lsc_auto_map = {'defaults': v:true, 'Completion': 'omnifunc'}
let g:lsc_enable_autocomplete = v:false
let g:lsc_enable_diagnostics = v:false
let g:lsc_server_commands = {}
if executable('ccls')
  function! FindProjectRoot()
    let marker = findfile('compile_commands.json', expand('%:p') . ';')
    if !marker
      let marker = findfile('.ccls', expand('%:p') . ';')
    endif
    if !marker
      let marker = finddir('.git', expand('%:p') . ';')
    endif
    return lsc#uri#documentUri(fnamemodify(marker, ':p:h'))
  endfunction

  let g:lsc_server_commands['cpp'] = {
    \ 'command': 'ccls',
    \ 'suppress_stderr': v:true,
    \ 'message_hooks': {
    \   'initialize': {
    \     'initializationOptions': {'cache': {'directory': '/tmp/ccls-cache'}},
    \     'rootUri': {m, p -> FindProjectRoot()}
    \     },
    \   },
    \ }
endif
if executable('pyls')
  let g:lsc_server_commands['python'] = {
    \ 'command': 'pyls',
    \ 'suppress_stderr': v:true,
    \ }
endif
if executable('php-language-server')
  let g:lsc_server_commands['php'] = {
    \ 'command': 'php-language-server',
    \ 'suppress_stderr': v:true,
    \ }
endif

runtime! plugin/*.vim

"""""""""""""""""""""""""""""""""""""""""""""""""

set novb t_vb=    " Не бікати взагалі ніколи
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

" Find tailing white spaces
nnoremap <Leader><space> /\s\+$\\| \+\ze\t<cr>

" NetRW
let g:netrw_liststyle = 3

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if &t_Co == 256 || has("gui_running")
  augroup colors
    au!
    autocmd ColorScheme * hi Comment cterm=italic
  augroup END
  colors zenburn
  hi Comment cterm=italic
endif
