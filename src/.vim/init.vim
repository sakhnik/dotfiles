" vim: set et ts=2 sw=2:

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
set expandtab
set hidden

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
  set incsearch
endif
set clipboard=unnamed
set completeopt=menu,preview
set shortmess=ac
let mapleader=' '
let maplocalleader=' '
"set cmdheight=2
set lazyredraw
set laststatus=1

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

runtime autoload/plug.vim

let s:vimdir = fnamemodify(resolve(expand('<sfile>:p')), ':h')

call plug#begin(s:vimdir.'/plugged')
Plug 'https://github.com/junegunn/seoul256.vim.git'
Plug 'https://github.com/tomasr/molokai.git'

let s:sysname = strpart(system('uname'), 0, 4)
if s:sysname == 'MSYS'
  Plug 'https://github.com/ctrlpvim/ctrlp.vim.git'
    let g:ctrlp_user_command = {
      \ 'types': {
        \ 1: ['.git', 'cd %s && git ls-files'],
        \ 2: ['.hg', 'hg --cwd %s locate -I .'],
      \ },
      \ 'fallback': 'dir %s /-n /b /s /a-d'
    \ }
    nmap <leader>ff :CtrlP<cr>
else
  Plug 'https://github.com/junegunn/fzf.git', { 'do': './install --bin' }
  Plug 'https://github.com/junegunn/fzf.vim.git'
    nmap <leader>ff :Files<cr>
    nmap <leader>fg :GitFiles<cr>
    nmap <leader>ft :Tags<cr>
endif

if !has('nvim')
  Plug 'https://github.com/tpope/vim-sensible.git'
endif

Plug 'https://github.com/tpope/vim-fugitive.git'          " :Git
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

Plug 'https://github.com/gregsexton/gitv.git', {'on': 'Gitv'}

Plug 'https://github.com/tpope/vim-eunuch.git'            " :SudoWrite
Plug 'https://github.com/tpope/vim-repeat.git'            " Repeat mapping with .
Plug 'https://github.com/tpope/vim-sleuth.git'            " Set buffer options euristically
Plug 'https://github.com/tpope/vim-unimpaired.git'        " ]q, ]a etc
Plug 'https://github.com/tpope/vim-surround.git'          " Movements s', s(
Plug 'https://github.com/tpope/vim-vinegar.git'
Plug 'https://github.com/bronson/vim-visual-star-search.git'
Plug 'https://github.com/vim-scripts/dbext.vim.git', { 'on': 'Dbext' }
Plug 'https://github.com/raimondi/delimitmate.git'
Plug 'https://github.com/drmikehenry/vim-fontsize.git'
Plug 'https://github.com/wellle/targets.vim.git'
"Plug 'https://github.com/sheerun/vim-polyglot.git'
Plug 'https://github.com/tpope/vim-git.git'
Plug 'https://github.com/vim-jp/vim-cpp.git'
Plug 'https://github.com/octol/vim-cpp-enhanced-highlight.git'
Plug 'https://github.com/godlygeek/tabular.git'
Plug 'https://github.com/mh21/errormarker.vim.git'
Plug 'https://github.com/plasticboy/vim-markdown.git'
  let g:vim_markdown_folding_disabled = 1
  let g:vim_markdown_frontmatter = 1
  let g:vim_markdown_no_default_key_mappings = 1
Plug 'https://github.com/suan/vim-instant-markdown.git'
  let g:instant_markdown_autostart = 0
Plug 'https://github.com/LaTeX-Box-Team/LaTeX-Box.git'

Plug 'https://github.com/andymass/vim-matchup.git'
  let g:matchup_matchparen_status_offscreen = 0

Plug 'https://github.com/majutsushi/tagbar.git'
  nnoremap <leader>tb :TagbarToggle<cr>

Plug 'https://github.com/Kris2k/A.vim.git'
  let g:alternateExtensions_cc = "hh,h,hpp"
  let g:alternateExtensions_hh = "cc"
  let g:alternateExtensions_hxx = "cxx"
  let g:alternateExtensions_cxx = "hxx,h"

Plug 'https://github.com/simnalamburt/vim-mundo.git'
  nnoremap <leader>uu :GundoToggle<cr>

Plug 'https://github.com/nathanaelkane/vim-indent-guides.git', { 'on': ['IndentGuidesToggle', 'IndentGuidesEnable'] }
  let g:indent_guides_guide_size = 1
  let g:indent_guides_color_change_percent = 20
  nmap <leader>ig :IndentGuidesToggle<cr>

Plug 'https://github.com/mhinz/vim-grepper.git'
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

Plug 'https://github.com/ledger/vim-ledger.git'
  let g:ledger_extra_options = '--pedantic --explicit --check-payees --price-db prices.db'
  let g:ledger_align_at = 45
  let g:ledger_default_commodity = '₴'
  let g:ledger_commodity_before = 0
  let g:ledger_commodity_sep = ' '
  let g:ledger_fold_blanks = 1

Plug 'https://github.com/sakhnik/nvim-gdb.git'

  "nnoremap <leader>dd :GdbStart gdb -q -f a.out

Plug 'https://github.com/Shougo/deoplete.nvim.git', { 'do': ':UpdateRemotePlugins' }
Plug 'https://github.com/Shougo/neosnippet.git'
Plug 'https://github.com/Shougo/neosnippet-snippets.git'
  let g:deoplete#enable_at_startup = 1
  let g:deoplete#enable_smart_case = 1
  let g:deoplete#auto_complete_delay = 200  " increase after the default 50

  let g:deoplete#sources = {}
  let g:deoplete#sources._ = ['buffer']
  let g:deoplete#sources.cpp = ['omni', 'LanguageClient']
  let g:deoplete#sources.ledger = ['omni']

  " Enable snipMate compatibility feature.
  let g:neosnippet#enable_snipmate_compatibility = 1
  imap <expr><TAB> pumvisible() ? "\<C-n>" : (neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>")
  imap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
  imap <expr><CR> pumvisible() ? deoplete#mappings#close_popup() : "\<CR>"

  " For conceal markers.
  "if has('conceal')
  "  set conceallevel=2 concealcursor=niv
  "endif

Plug 'https://github.com/autozimu/LanguageClient-neovim.git', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

  let g:LanguageClient_serverCommands = {
      \ 'cpp': ['cquery', '--language-server', '--log-file=/tmp/cq.log'],
      \ 'python': ['pyls', '--log-file=/tmp/pyls.log'],
      \ }
  let g:LanguageClient_loadSettings = 1
  let g:LanguageClient_settingsPath = s:vimdir . '/cquery.json'
  let g:LanguageClient_diagnosticsList = "Location"
  let g:LanguageClient_selectionUI = "location-list"
  let g:LanguageClient_hasSnippetSupport = 1

  nnoremap <leader>li :call LanguageClient_textDocument_hover()<cr>
  nnoremap <leader>lj :call LanguageClient_textDocument_definition()<cr>
  nnoremap <leader>lw :call LanguageClient_textDocument_rename()<cr>
  nnoremap <leader>ls :call LanguageClient_textDocument_documentSymbol() <bar> lopen<cr>
  nnoremap <leader>lf :call LanguageClient_textDocument_references() <bar> lopen<cr>
  nnoremap <leader>lS :call LanguageClient_workspace_symbol() <bar> lopen<cr>
  nnoremap <leader>ll :call LanguageClientMyToggle()<cr>

  " Language servers are started per file type.
  " My requirements:
  "   * show hover automatically for the activated file types
  "   * show signcolumn for the activated file types
  "   * hide signcolumn in the unfocused windows

  " List of active filetypes
  let g:ls_started_filetypes = []

  function! LanguageClientMyToggle()
    if index(g:ls_started_filetypes, &filetype) != -1
      LanguageClientStop
    else
      LanguageClientStart
    endif
  endfunction

  augroup LanguageClient_config
    au!
    au BufEnter * if index(g:ls_started_filetypes, &filetype) != -1 | setl signcolumn=yes | endif
    au BufLeave,WinLeave * setl signcolumn=auto
    au User LanguageClientStarted call insert(g:ls_started_filetypes, &filetype) | setl signcolumn=yes
    au User LanguageClientStopped call remove(g:ls_started_filetypes, &filetype) | setl signcolumn=auto
    "au CursorMoved * if index(g:ls_started_filetypes, &filetype) != -1 | call LanguageClient_textDocument_hover() | endif
  augroup END

call plug#end()

runtime! plugin/*.vim

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

"" Doxygen parser
"let &efm = &efm . ',%f:%l\ %m'
"

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
