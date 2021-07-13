-- vim: set et ts=2 sw=2:
--

local cmd = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if vim.loop.fs_stat(install_path) == nil then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  cmd 'packadd packer.nvim'
end

require'packer'.startup(function()
  use 'wbthomason/packer.nvim'  -- Manager packer itself

  use 'jnurmine/zenburn'

  use 'tpope/vim-fugitive'
  use 'tpope/vim-eunuch'            -- :SudoWrite
  use 'tpope/vim-repeat'            -- Repeat mapping with .
  use 'tpope/vim-sleuth'            -- Set buffer options euristically
  use 'tpope/vim-unimpaired'        -- ]q, ]a etc
  use 'tpope/vim-surround'          -- Movements s', s(
  use 'tpope/vim-vinegar'
  use 'bronson/vim-visual-star-search'
  use 'raimondi/delimitmate'
  use 'wellle/targets.vim'
  use 'sheerun/vim-polyglot'
  use 'mh21/errormarker.vim'
  use 'sirtaj/vim-openscad'
  use 'plasticboy/vim-markdown'
  use 'andymass/vim-matchup'
  use 'majutsushi/tagbar'
  use 'Kris2k/A.vim'
  use 'ledger/vim-ledger'
  use 'sakhnik/nvim-gdb'
  use {'neovim/nvim-lspconfig', opt = true}
  use {'nvim-lua/completion-nvim', opt = true}
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'

  use 'nvim-telescope/telescope.nvim'
  use 'nvim-telescope/telescope-project.nvim'
end)

local keymap = vim.api.nvim_set_keymap

local noremap_silent = {noremap = true, silent = true}
keymap('n', '<leader>ff', ':Telescope find_files<cr>', noremap_silent)
keymap('n', '<leader>fg', ':Telescope git_files<cr>', noremap_silent)
keymap('n', '<leader>f<space>', ':Telescope builtin<cr>', noremap_silent)
keymap('n', '<leader>gg', ':Telescope live_grep<cr>', noremap_silent)
keymap('n', '<leader>fc', ':Telescope current_buffer_fuzzy_find<cr>', noremap_silent)
keymap('n', '<leader>fp', ":lua require'telescope'.extensions.project.project{}<CR>", noremap_silent)

vim.g.ledger_bin = 'ledger'
vim.g.ledger_date_format = '%Y-%m-%d'
vim.g.ledger_extra_options = '--pedantic --explicit --price-db prices.db --date-format ' .. vim.g.ledger_date_format
vim.g.ledger_align_at = 45
vim.g.ledger_default_commodity = '₴'
vim.g.ledger_commodity_before = 0
vim.g.ledger_commodity_sep = ' '
vim.g.ledger_fold_blanks = 1

vim.g.polyglot_disabled = {'sensible'}

local utils = require'local.utils'
utils.create_augroup('plugins', {
  -- Recompile packer configuration automatically
  [[BufWritePost plugins.lua source <afile> | PackerCompile]],
})
