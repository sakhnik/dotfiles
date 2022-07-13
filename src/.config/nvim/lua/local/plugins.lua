-- vim: set et ts=2 sw=2:
--

local cmd = vim.api.nvim_command

local paqpath = vim.fn.stdpath('data') .. '/site/pack/paqs/opt/paq-nvim'
local stat = vim.loop.fs_stat(paqpath)
if stat == nil then
  vim.fn.mkdir(paqpath, 'p')
  cmd("!git clone https://github.com/savq/paq-nvim.git " .. paqpath)
end

cmd 'packadd paq-nvim'              -- Load package

require'paq' {
  {'savq/paq-nvim', opt=true};      -- Let Paq manage itself

  'jnurmine/zenburn';
  'mhartington/oceanic-next';
  'savq/melange';
  'ellisonleao/gruvbox.nvim';

  'tpope/vim-fugitive';
  'tpope/vim-eunuch';               -- :SudoWrite
  'tpope/vim-repeat';               -- Repeat mapping with .
  'tpope/vim-sleuth';               -- Set buffer options euristically
  'tpope/vim-unimpaired';           -- ]q, ]a etc
  'tpope/vim-surround';             -- Movements s', s(
  'tpope/vim-vinegar';
  'bronson/vim-visual-star-search';
  'raimondi/delimitmate';
  'wellle/targets.vim';
  'sheerun/vim-polyglot';
  'mh21/errormarker.vim';
  'sirtaj/vim-openscad';
  'plasticboy/vim-markdown';
  'andymass/vim-matchup';
  'majutsushi/tagbar';
  'Kris2k/A.vim';
  'ledger/vim-ledger';
  {'sakhnik/nvim-gdb', branch="devel"};

  {url = 'https://gitlab.com/yorickpeterse/nvim-pqf'};  -- pretty quickfix

  -- It's necessary to declare all plugins in one place
  -- telescope
  'nvim-lua/popup.nvim';
  'nvim-lua/plenary.nvim';
  'nvim-telescope/telescope.nvim';
  'nvim-telescope/telescope-project.nvim';

  -- lsp
  'neovim/nvim-lspconfig';
  'williamboman/nvim-lsp-installer';
  'hrsh7th/cmp-nvim-lsp';
  'hrsh7th/cmp-buffer';
  'hrsh7th/nvim-cmp';
  'L3MON4D3/LuaSnip';
  'saadparwaiz1/cmp_luasnip';
  'ray-x/lsp_signature.nvim';

  -- TreeSitter
  {'nvim-treesitter/nvim-treesitter', run=':TSUpdate'};
}

vim.g.polyglot_disabled = {'sensible'}

require('pqf').setup()  -- pretty quickfix

require'local/lsp'.setup()  -- initialize LSP completion immediately
require'local/mytelescope'.setup()
require'local/ledger'.setup()
require'local/treesitter'.setup()
