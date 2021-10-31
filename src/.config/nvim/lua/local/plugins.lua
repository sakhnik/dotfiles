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

paq {url = 'https://gitlab.com/yorickpeterse/nvim-pqf'}  -- pretty quickfix

vim.g.polyglot_disabled = {'sensible'}

require('pqf').setup()  -- pretty quickfix

require'local/lsp'.setup()  -- initialize LSP completion immediately
require'local/telescope'.setup()
require'local/ledger'.setup()
