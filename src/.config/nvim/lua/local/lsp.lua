local C = {}

local cmd = vim.api.nvim_command

local function configureBuffer()
  vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

  local set_keymap = vim.api.nvim_buf_set_keymap
  local buf = vim.api.nvim_get_current_buf()
  local opts = {noremap = true, silent = true}
  set_keymap(buf, 'n', 'gd', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  set_keymap(buf, 'n', '<c-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  set_keymap(buf, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  set_keymap(buf, 'n', 'gD', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  set_keymap(buf, 'n', '<c-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  set_keymap(buf, 'n', '1gD', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  set_keymap(buf, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  set_keymap(buf, 'n', 'g0', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
  set_keymap(buf, 'n', 'gW', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)

  -- Set completeopt to have a better completion experience
  cmd "setlocal completeopt=menu,menuone,noselect"

  -- Avoid showing message extra message when using completion
  cmd "setlocal shortmess+=c"
  vim.wo.signcolumn = 'yes'
end

local function get_caps()
  return require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
end

function C.setup()

  cmd "packadd nvim-lspconfig"
  cmd "packadd cmp-nvim-lsp"
  cmd "packadd cmp-buffer"
  cmd "packadd nvim-cmp"

  -- Stop existing clients (useful to reload after crash)
  --vim.lsp.stop_client(vim.lsp.buf_get_clients())

  require'lspconfig'.bashls.setup{on_attach = configureBuffer, capabilities = get_caps()}
  require'lspconfig'.vala_ls.setup{on_attach = configureBuffer, capabilities = get_caps()}
  require'lspconfig'.pylsp.setup{on_attach = configureBuffer, capabilities = get_caps()}
  require'lspconfig'.clangd.setup{on_attach = configureBuffer, capabilities = get_caps()}
  require'lspconfig'.sumneko_lua.setup {
    cmd = {"/usr/bin/lua-language-server"},

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
    },

    on_attach = configureBuffer,
    capabilities = get_caps(),
  }

  -- Setup nvim-cmp.
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
    -- snippet = {
    --   expand = function(args)
    --     -- For `vsnip` user.
    --     vim.fn["vsnip#anonymous"](args.body)

    --     -- For `luasnip` user.
    --     -- require('luasnip').lsp_expand(args.body)

    --     -- For `ultisnips` user.
    --     -- vim.fn["UltiSnips#Anon"](args.body)
    --   end,
    -- },
    mapping = {
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<Tab>'] = function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end
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
end

function C.clearSigns()
  vim.api.nvim_buf_clear_namespace(0, -1, 0, -1)
  cmd "sign unplace * group=*"
end

return C
