local C = {}

local cmd = vim.api.nvim_command

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
    callback = function() require('local.lsp').show_line_diagnostics() end,
    buffer = vim.api.nvim_get_current_buf(),
  })

  -- Set completeopt to have a better completion experience
  cmd "setlocal completeopt=menu,menuone,noselect"

  -- Avoid showing message extra message when using completion
  cmd "setlocal shortmess+=c"
  vim.wo.signcolumn = 'yes'

  require "lsp_signature".on_attach()
end

local function get_caps()
  return require('cmp_nvim_lsp').default_capabilities()
end

-- Launch Java language server automatically
local function setup_java()
  if C.setup_java_cmd == nil then
    C.setup_java_cmd = vim.api.nvim_create_autocmd("FileType", {
      pattern = "java",
      callback = function()
        -- LSP clients are attached on FileType too. So we may need to restart the LSP
        -- after reconfiguring if it was running before.
        local clients = vim.lsp.buf_get_clients()
        local jls_client_id = nil
        for id, client in ipairs(clients) do
          if client.name == "java-language-server" then
            jls_client_id = id
            break
          end
        end
        -- Configure JLS
        C.java()
        if jls_client_id ~= nil then
          vim.api.nvim_command("LspRestart " .. jls_client_id)
        end
      end
    })
  end
end

function C.setup()

  -- Stop existing clients (useful to reload after crash)
  --vim.lsp.stop_client(vim.lsp.buf_get_clients())

  require("mason").setup()
  require("mason-lspconfig").setup()

  -- Register a handler that will be called for each installed server when it's ready (i.e. when installation is finished
  -- or if the server is already installed).
  local lspconfig = require'lspconfig'

  require("mason-lspconfig").setup_handlers {
    function (server_name)
      local opts = {
        on_attach = C.configureBuffer,
        capabilities = get_caps()
      }
      lspconfig[server_name].setup(opts)
    end,

    ['clangd'] = function()
      local opts = {
        on_attach = C.configureBuffer,
        capabilities = get_caps(),
        cmd = { "clangd", "--completion-style=detailed", "--enable-config" }
      }
      lspconfig.clangd.setup(opts)
    end,

    ['lua_ls'] = function()
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
              globals = {'vim'},
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = {
                [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
              },
            },
          },
        }
      }
      lspconfig.lua_ls.setup(opts)
    end,
  }

  -- Setup nvim-cmp.
  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end

  local luasnip = require("luasnip")
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
        require('luasnip').lsp_expand(args.body)

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
    underline = false,
    virtual_text = false,
    signs = true,
    severity_sort = true,
  })

  setup_java()
end

function C.clearSigns()
  vim.api.nvim_buf_clear_namespace(0, -1, 0, -1)
  cmd "sign unplace * group=*"
end

function C.java()
  local jls = "java-language-server"
  -- local jls = "e:/java-language-server/dist/lang_server_windows.cmd"
  if 0 == vim.fn.executable(jls) then
    print("The executable for java-language-server not found: " .. jls)
    print("Consider installing it and tweaking stdpath('config')/lua/local/lsp.lua")
    return
  end

  local deps = {}
  local jars = {}
  if 0 ~= vim.fn.filereadable('.deps') then
    for dep in io.lines('.deps') do
      deps[#deps + 1] = dep
    end
  elseif 0 == vim.fn.filereadable('.jars') then
    print("Neither .deps (from gradle dependencies) nor .jars (one JAR per line) are found")
  else
    for jar in io.lines('.jars') do
      jars[#jars + 1] = jar
    end
  end

  local opts = {
    on_attach = C.configureBuffer,
    capabilities = get_caps(),
    cmd = { jls },
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

return C
