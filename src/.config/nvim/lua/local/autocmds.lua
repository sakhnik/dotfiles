local M = {}
local cmd = vim.api.nvim_command

local augid = vim.api.nvim_create_augroup('misc', {clear = true})

-- When editing a file, always jump to the last known cursor position.
-- Don't do it when the position is invalid or when inside an event handler
-- (happens when dropping a file on gvim).
vim.api.nvim_create_autocmd('BufReadPost', {
  group = augid,
  pattern = '*',
  callback = function()
    local line = vim.fn.line
    if line([['"]]) > 0 and line([['"]]) <= line("$") then
      cmd [[normal g`"]]
    end
  end
})

-- Don't preserve a buffer when reading from stdin
-- This is useful for "git diff | vim -"
vim.api.nvim_create_autocmd('StdinReadPost', {
  group = augid,
  pattern = '*',
  callback = function() vim.bo.buftype = 'nofile' end
})

-- For all text files set 'textwidth' to 78 characters.
vim.api.nvim_create_autocmd('FileType', {
  group = augid,
  pattern = 'text',
  callback = function()
    vim.bo.textwidth = 78
    vim.wo.lbr = true
  end
})

vim.api.nvim_create_autocmd('FileType', {
  group = augid,
  pattern = 'gitcommit',
  callback = function()
    vim.wo.spell = true
  end
})

-- Highlight yanked text briefly
vim.api.nvim_create_autocmd('TextYankPost', {
  group = augid,
  pattern = '*',
  callback = function()
    vim.highlight.on_yank {higroup="IncSearch", timeout=150, on_visual=true}
  end
})

return M
