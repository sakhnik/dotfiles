local M = {}
local utils = require'local.utils'
local cmd = vim.api.nvim_command

function M.restore_cursor()
  local line = vim.fn.line
  if line([['"]]) > 0 and line([['"]]) <= line("$") then
    cmd [[normal g`"]]
  end
end

utils.create_augroup('misc', {
  -- When editing a file, always jump to the last known cursor position.
  -- Don't do it when the position is invalid or when inside an event handler
  -- (happens when dropping a file on gvim).
  [[BufReadPost * call v:lua.require('local.autocmds').restore_cursor()]],

  -- Don't preserve a buffer when reading from stdin
  -- This is useful for "git diff | vim -"
  [[StdinReadPost * setlocal buftype=nofile]],

  -- For all text files set 'textwidth' to 78 characters.
  [[FileType text setlocal textwidth=78 lbr]],
  [[FileType gitcommit setlocal spell]],
})

return M
