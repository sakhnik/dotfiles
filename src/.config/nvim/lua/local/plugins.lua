-- vim: set et ts=2 sw=2:
--

local cmd = vim.api.nvim_command

return function()

  local paqpath = vim.fn.stdpath('data') .. '/site/pack/paqs/opt/paq-nvim'
  local stat = vim.loop.fs_stat(paqpath .. '/lua')
  if stat == nil then
    vim.fn.mkdir(paqpath, 'p')
    --vim.cmd('!git clone https://github.com/savq/paq-nvim.git ' .. paqpath)
    local co = coroutine.running()
    local job_id = vim.fn.jobstart({'git', 'clone', 'https://github.com/savq/paq-nvim.git', paqpath}, {
      on_stdout = function(_, d, _)
        print(table.concat(d, '\n'))
      end,
      on_stderr = function(_, d, _)
        local output = table.concat(d, '\n')
        if output ~= '' then
          print('** ' .. output)
        end
      end,
      on_exit = function(_, code, _)
        if code ~= 0 then
          print('git exit code: ' .. code)
        end
        coroutine.resume(co)
      end
    })
    if job_id > 0 then
      -- Wait until the cloning is done
      coroutine.yield()
    elseif 0 == job_id then
      print("Invalid arg")
    elseif -1 == job_id then
      error("No git")
    else
      print("Unknown err")
    end
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
    'kylechui/nvim-surround';         -- Movements s', s(
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
    'nvim-telescope/telescope-live-grep-args.nvim';

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
    'mfussenegger/nvim-jdtls';

    -- TreeSitter
    'nvim-treesitter/nvim-treesitter';
    'nvim-treesitter/playground';

    'nvim-tree/nvim-tree.lua';
    'nvim-tree/nvim-web-devicons';
    'stevearc/oil.nvim';
  }

  -- Detect if plugin installation is required
  local orig_require = require

  ---Try loading module, install plugins if required
  ---@param module string module name
  ---@return any whatever the module returns
  local function paq_require(module)
    local ok, res = pcall(orig_require, module)
    if ok then
      return res
    end
    -- A couple of exceptions not directly related to a plugin installation
    if module:find("mason%-lspconfig%.server_configurations") or module:find("jsregexp") then
      return res
    end
    local co = coroutine.running()
    local auid = vim.api.nvim_create_autocmd('User', {
      pattern = 'PaqDoneInstall',
      callback = vim.schedule_wrap(function()
        coroutine.resume(co)
      end),
    })
    orig_require'paq'.install()
    coroutine.yield()
    vim.api.nvim_del_autocmd(auid)
    return orig_require(module)
  end

  -- Do the checked importing from now on
  require = paq_require

  vim.g.polyglot_disabled = {'sensible'}

  require("nvim-tree").setup()
  vim.keymap.set('n', '<leader>nn', function() require("nvim-tree.api").tree.toggle() end, {})

  require'nvim-surround'.setup()
  require'pqf'.setup()  -- pretty quickfix

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

  require("oil").setup()
  vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })

  -- Restore the original module loading, no more automatic plugin installation
  require = orig_require

end
