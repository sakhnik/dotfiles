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

if empty(glob(s:vimdir.'/autoload/plug.vim'))
  exe 'silent !curl -fLo '.s:vimdir.'/autoload/plug.vim --create-dirs'.
    \ ' https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

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
  let g:targets_aiAI = 'aIAi'
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
Plug 'https://github.com/leafo/moonscript-vim.git'

Plug 'https://github.com/andymass/vim-matchup.git'
  let g:matchup_matchparen_status_offscreen = 0

Plug 'https://github.com/majutsushi/tagbar.git'
  nnoremap <leader>tb :TagbarToggle<cr>

Plug 'https://github.com/Kris2k/A.vim.git'
  let g:alternateExtensions_cc = "hh,h,hpp"
  let g:alternateExtensions_hh = "cc"
  let g:alternateExtensions_hxx = "cxx"
  let g:alternateExtensions_cxx = "hxx,h"
  let g:alternateExtensions_moon = "lua"
  let g:alternateExtensions_lua = "moon"

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

Plug 'https://github.com/SirVer/ultisnips.git'
Plug 'https://github.com/honza/vim-snippets.git'
  let g:UltiSnipsExpandTrigger="<c-b>"
  "let g:UltiSnipsJumpForwardTrigger="<c-j>"
  "let g:UltiSnipsJumpBackwardTrigger="<c-k>"

  function! ExpandLspSnippet()
    call UltiSnips#ExpandSnippetOrJump()
    if !pumvisible() || empty(v:completed_item)
      return ''
    endif

    " only expand Lsp if UltiSnips#ExpandSnippetOrJump not effect.
    let l:value = v:completed_item['word']
    let l:matched = len(l:value)
    if l:matched <= 0
      return ''
    endif

    " remove inserted chars before expand snippet
    if col('.') == col('$')
      let l:matched -= 1
      exec 'normal! ' . l:matched . 'Xx'
    else
      exec 'normal! ' . l:matched . 'X'
    endif

    if col('.') == col('$') - 1
      " move to $ if at the end of line.
      call cursor(line('.'), col('$'))
    endif

    " expand snippet now.
    call UltiSnips#Anon(l:value)
    return ''
  endfunction

  imap <C-j> <C-R>=ExpandLspSnippet()<CR>

Plug 'https://github.com/sakhnik/vim-lsc'
  let g:lsc_auto_map = {'defaults': v:true, 'Completion': 'omnifunc'}
  let g:lsc_enable_autocomplete = v:false
  let g:lsc_enable_diagnostics = v:false
  let g:lsc_server_commands = {}
  if executable('cquery')
    let cqueryInit = {
      \ "cacheDirectory": "/tmp/cquery-cache",
      \ "progressReportFrequencyMs": -1,
      \ }
    let g:lsc_server_commands['cpp'] = {
      \   'command': 'cquery --init="' . escape(json_encode(cqueryInit), '"') . '"',
      \   'suppress_stderr': v:true,
      \ }
  endif
  if executable('pyls')
    let g:lsc_server_commands['python'] = {
      \ 'command': 'pyls',
      \ 'suppress_stderr': v:true,
      \ }
  endif

call plug#end()

runtime! plugin/*.vim

"""""""""""""""""""""""""""""""""""""""""""""""""""
" YouCompleteMe stuff
" The plugin should be delpoyed by the script ycm-update.sh

if isdirectory(s:vimdir . '/YouCompleteMe')
  let g:ycm_filetype_whitelist = {
    \ 'cpp' : 1,
    \ 'python' : 1,
    \}
  "let g:ycm_collect_identifiers_from_tags_files = 1 " Let YCM read tags from Ctags file
  "let g:ycm_seed_identifiers_with_syntax = 1 " Completion for programming language's keyword
  let g:ycm_complete_in_comments = 1 " Completion in comments
  let g:ycm_complete_in_strings = 1 " Completion in string
  "let g:ycm_always_populate_location_list = 1

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
