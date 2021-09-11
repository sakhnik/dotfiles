-- vim: set et ts=2 sw=2:
--

local cmd = vim.api.nvim_command
local set_keymap = vim.api.nvim_set_keymap

vim.o.fileencodings = 'utf-8,cp1251,default'
vim.o.wildmode = 'longest,list,full'
vim.o.diffopt = vim.o.diffopt .. ',iwhite'
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.tabstop = 4
vim.o.cindent = true
vim.o.shiftwidth = 4
vim.o.cinoptions = ":0,=1s,g0,(0,M1,U0,u0"
vim.o.copyindent = true
vim.o.expandtab = true
vim.o.hidden = true
vim.o.mouse = 'a'
vim.o.termguicolors = true
vim.o.completeopt = 'menu,preview'
vim.o.shortmess = 'ac'
if vim.fn.has('win32') == 1 then
  vim.o.shellslash = true
end

cmd [[let mapleader = ' ']]
cmd [[let maplocalleader = ' ']]

vim.o.lazyredraw = true
vim.o.laststatus = 1

require 'local.plugins'
require 'local.digraphs'
require 'local.autocmds'

-- Configure colorscheme zenburn
local utils = require'local.utils'
utils.create_augroup('colors', {
  [[ColorScheme * hi Comment cterm=italic gui=italic]]
})
cmd 'colors zenburn'

-- Initialize nvim-lsp. Not calling this will allow using YouCompleteMe,
-- for example.
set_keymap('n', '<leader>ll', '<cmd>lua require"local.lsp".init()<cr>', {})
set_keymap('n', '<leader>lc', '<cmd>lua require"local.lsp".clearSigns()<cr>', {})

-- Configure vim-ledger
vim.g.ledger_bin = 'ledger'
vim.g.ledger_date_format = '%Y-%m-%d'
vim.g.ledger_extra_options = '--pedantic --explicit --price-db prices.db --date-format ' .. vim.g.ledger_date_format
vim.g.ledger_align_at = 45
vim.g.ledger_default_commodity = '₴'
vim.g.ledger_commodity_before = 0
vim.g.ledger_commodity_sep = ' '
vim.g.ledger_fold_blanks = 1

vim.o.showbreak = '\\'  --↪
vim.o.undofile = true

-- Forget about ex mode
set_keymap('', 'Q', '<nop>', {})

-- Find tailing white spaces
set_keymap('n', '<Leader><space>', [[/\s\+$\\| \+\ze\t<cr>]], {noremap = true})

-- NetRW
vim.g.netrw_liststyle = 3
