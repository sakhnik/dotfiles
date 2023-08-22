local C = {}

local cmd = vim.api.nvim_command

C.plugins = {
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
}

function C.show_line_diagnostics()
  local opts = {
    focusable = false,
    close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
    border = 'rounded',
    source = 'always',  -- show source in diagnostic popup window
    prefix = ' '
  }
  vim.diagnostic.open_float(nil, opts)
end

function C.configureBuffer() --(client, bufnr)
  vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

  local opts = {noremap = true, silent = true, buffer = true}
  vim.keymap.set('n', 'gd', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', '<c-]>', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', '<c-k>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '1gD', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', 'g0', vim.lsp.buf.document_symbol, opts)
  vim.keymap.set('n', 'gW', vim.lsp.buf.workspace_symbol, opts)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
  vim.keymap.set("n", "<space>q", function() vim.diagnostic.setqflist({open = true}) end, opts)
  vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, opts)

  vim.api.nvim_create_autocmd("CursorHold", {
    callback = function() require'local.modules.lsp'.show_line_diagnostics() end,
    buffer = vim.api.nvim_get_current_buf(),
  })

  -- Set completeopt to have a better completion experience
  cmd "setlocal completeopt=menu,menuone,noselect"

  -- Avoid showing message extra message when using completion
  cmd "setlocal shortmess+=c"
  vim.wo.signcolumn = 'yes'

  require"lsp_signature".on_attach()
end

local function get_caps()
  return require'cmp_nvim_lsp'.default_capabilities()
end

local function setup_java_ls()
  local deps = {}
  local jars = {}
  if 0 ~= vim.fn.filereadable('.deps') then
    for dep in io.lines('.deps') do
      deps[#deps + 1] = dep
    end
  end
  if 0 ~= vim.fn.filereadable('.jars') then
    for jar in io.lines('.jars') do
      jars[#jars + 1] = jar
    end
  end

  local opts = {
    on_attach = C.configureBuffer,
    capabilities = get_caps(),
    cmd = { "java-language-server" },
    root_dir = function() return vim.fs.dirname(vim.fs.find({'.git', '.hg'}, { upward = true })[1]) end,
    settings = {
      java = {
        externalDependencies = deps,
        classPath = jars
      }
    }
  }
  local lspconfig = require'lspconfig'
  lspconfig.java_language_server.setup(opts)
end

local function setup_lua_ls()
  local library = {}
  -- Exclude the locally installed plugins
  for _, path in ipairs(vim.api.nvim_get_runtime_file("", true)) do
    if not path:find("%.local/share/nvim") then
      library[#library+1] = path
    end
  end
  library[#library + 1] = '/home/sakhnik/work/nvim-gdb/./lua_modules/share/lua/5.1/?.lua'
  library[#library + 1] = '/home/sakhnik/work/nvim-gdb/./lua_modules/share/lua/5.1/?/init.lua'

  local opts = {
    on_attach = C.configureBuffer,
    capabilities = get_caps(),
    cmd = { "lua-language-server" },
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
          -- Setup your lua path
          path = vim.split(package.path, ';'),
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = {'vim', 'nvim', 'describe', 'it'},
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = library,
        },
      },
    }
  }
  require'lspconfig'.lua_ls.setup(opts)
end

local function setup_jdtls()
  -- Don't setup, jdtls will be handled by the dedicated plugin.
  --require'lspconfig'.jdtls.setup(opts)
end

local function setup_clangd()
  local opts = {
    on_attach = C.configureBuffer,
    capabilities = get_caps(),
    cmd = { "clangd", "--completion-style=detailed", "--enable-config" }
  }
  require'lspconfig'.clangd.setup(opts)
end

function C.setup()

  require"mason".setup()
  require"mason-lspconfig".setup()

  -- Register a handler that will be called for each installed server when it's ready (i.e. when installation is finished
  -- or if the server is already installed).
  local lspconfig = require'lspconfig'

  require"mason-lspconfig".setup_handlers {
    function (server_name)
      local opts = {
        on_attach = C.configureBuffer,
        capabilities = get_caps()
      }
      lspconfig[server_name].setup(opts)
    end,

    clangd = setup_clangd,
    java_language_server = setup_java_ls,
    lua_ls = setup_lua_ls,
    jdtls = setup_jdtls,
  }

  -- Setup nvim-cmp.
  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end

  local luasnip = require"luasnip"
  local cmp = require'cmp'

  cmp.setup({
    enabled = function()
      if vim.api.nvim_buf_get_option(0, 'buftype') == 'prompt' then
        return false
      end
      if vim.api.nvim_buf_get_option(0, 'filetype') == 'ledger' then
        return false
      end
      return true
    end,
    snippet = {
      expand = function(args)
        -- For `vsnip` user.
        --vim.fn["vsnip#anonymous"](args.body)

        -- For `luasnip` user.
        require'luasnip'.lsp_expand(args.body)

        -- For `ultisnips` user.
        -- vim.fn["UltiSnips#Anon"](args.body)
      end,
    },
    mapping = {
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
      -- ['<Tab>'] = function(fallback)
      --   if cmp.visible() then
      --     cmp.select_next_item()
      --   else
      --     fallback()
      --   end
      -- end
    },
    sources = {
      { name = 'nvim_lsp' },

      -- For vsnip user.
      -- { name = 'vsnip' },

      -- For luasnip user.
      -- { name = 'luasnip' },

      -- For ultisnips user.
      -- { name = 'ultisnips' },

      { name = 'buffer' },
    },
  })

  vim.diagnostic.config({
    severity_sort = true,
  })

  vim.keymap.set('n', '<leader>ll', function() require"local.modules.lsp".setup() end, {})
  vim.keymap.set('n', '<leader>lc', function() require"local.modules.lsp".clearSigns() end, {})
end

function C.clearSigns()
  vim.api.nvim_buf_clear_namespace(0, -1, 0, -1)
  cmd "sign unplace * group=*"
end

return C
