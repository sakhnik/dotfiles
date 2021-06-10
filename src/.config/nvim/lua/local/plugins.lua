-- vim: set et ts=2 sw=2:
--

local cmd = vim.api.nvim_command

local paqpath = vim.fn.stdpath('data') .. '/site/pack/paqs/opt/paq-nvim'
local stat = vim.loop.fs_stat(paqpath)
if stat == nil then
  vim.fn.mkdir(paqpath, 'p')
  cmd("!git clone https://github.com/savq/paq-nvim.git " .. paqpath)
end

cmd 'packadd paq-nvim'             -- Load package
local paq = require'paq-nvim'.paq  -- Import module and bind `paq` function
paq {'savq/paq-nvim', opt=true}    -- Let Paq manage itself

paq {'jnurmine/zenburn'}

paq {'tpope/vim-fugitive'}
paq {'tpope/vim-eunuch'}            -- :SudoWrite
paq {'tpope/vim-repeat'}            -- Repeat mapping with .
paq {'tpope/vim-sleuth'}            -- Set buffer options euristically
paq {'tpope/vim-unimpaired'}        -- ]q, ]a etc
paq {'tpope/vim-surround'}          -- Movements s', s(
paq {'tpope/vim-vinegar'}
paq {'bronson/vim-visual-star-search'}
paq {'raimondi/delimitmate'}
paq {'wellle/targets.vim'}
paq {'sheerun/vim-polyglot'}
paq {'mh21/errormarker.vim'}
paq {'sirtaj/vim-openscad'}
paq {'plasticboy/vim-markdown'}
paq {'andymass/vim-matchup'}
paq {'majutsushi/tagbar'}
paq {'Kris2k/A.vim'}
paq {'ledger/vim-ledger'}
paq {'sakhnik/nvim-gdb'}
paq {'neovim/nvim-lspconfig', opt = true}
paq {'nvim-lua/completion-nvim', opt = true}
paq {'nvim-lua/popup.nvim'}
paq {'nvim-lua/plenary.nvim'}

paq {'nvim-telescope/telescope.nvim'}
paq {'nvim-telescope/telescope-project.nvim'}


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
