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
  'numToStr/FTerm.nvim';

  -- It's necessary to declare all plugins in one place
  -- telescope
  'nvim-lua/popup.nvim';
  'nvim-lua/plenary.nvim';
  'nvim-telescope/telescope.nvim';
  'nvim-telescope/telescope-project.nvim';

  -- lsp
  'williamboman/mason.nvim';
  'williamboman/mason-lspconfig.nvim';
  'neovim/nvim-lspconfig';
  'hrsh7th/cmp-nvim-lsp';
  'hrsh7th/cmp-buffer';
  'hrsh7th/nvim-cmp';
  'L3MON4D3/LuaSnip';
  'saadparwaiz1/cmp_luasnip';
  'ray-x/lsp_signature.nvim';

  -- TreeSitter
  {'nvim-treesitter/nvim-treesitter', run=function() vim.cmd('TSUpdate') end};
  { 'nvim-treesitter/playground' };
}

vim.g.polyglot_disabled = {'sensible'}

require('pqf').setup()  -- pretty quickfix

require'local/lsp'.setup()  -- initialize LSP completion immediately
require'local/mytelescope'.setup()
require'local/ledger'.setup()
require'local/treesitter'.setup()

local function get_shell()
  if vim.fn.has('win32') == 1 then
    return "powershell"
  end
  return os.getenv('SHELL')
end

require'FTerm'.setup({
    cmd = get_shell(),
})

-- Example keybindings
vim.keymap.set('n', '<A-i>', function() require("FTerm").toggle() end, {})
vim.keymap.set('t', '<A-i>', function()
  vim.api.nvim_input('<C-\\><C-n>')
  require("FTerm").toggle()
end, {})
