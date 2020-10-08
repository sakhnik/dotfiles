
if exists("loaded_autocmds_plugin") || !has("autocmd")
  finish
endif
let loaded_autocmds_plugin = 1

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
