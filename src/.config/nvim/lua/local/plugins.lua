-- vim: set et ts=2 sw=2:
--

local cmd = vim.api.nvim_command

return function()

  local modules = {
    require'local.modules.color',
    require'local.modules.vim',
    require'local.modules.telescope',
    require'local.modules.fs',
    require'local.modules.lsp',
    require'local.modules.treesitter',
    require'local.modules.term',
    require'local.modules.quickfix',
  }

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

  local plugins = {
    {'savq/paq-nvim', opt=true};      -- Let Paq manage itself
    {'sakhnik/nvim-gdb', branch="devel"};
  }

  -- collect plugins from the modules
  do
    local plugin_map = {}
    for _, plugin in ipairs(plugins) do
      plugin_map[plugin] = true
    end
    for _, module in ipairs(modules) do
      for _, plugin in ipairs(module.plugins) do
        if not plugin_map[plugin] then
          table.insert(plugins, plugin)
          plugin_map[plugin] = true
        end
      end
    end
  end

  -- Declare the list of plugins to Paq
  require'paq'(plugins)

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
    print("Installing plugins for " .. module)
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

  -- Setup modules
  for _, module in ipairs(modules) do
    if module.setup then
      module.setup()
    end
  end

  -- Restore the original module loading, no more automatic plugin installation
  require = orig_require

end
