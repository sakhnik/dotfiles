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

  -- Use completion-nvim in this buffer
  require'completion'.on_attach()

  -- Use <Tab> and <S-Tab> to navigate through popup menu
  opts = {noremap = true, silent = true, expr = true}
  set_keymap(buf, 'i', '<Tab>', [[pumvisible() ? "\<C-n>" : "\<Tab>"]], opts)
  set_keymap(buf, 'i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], opts)

  -- Set completeopt to have a better completion experience
  cmd "setlocal completeopt=menuone,noinsert,noselect"

  -- Avoid showing message extra message when using completion
  cmd "setlocal shortmess+=c"
  vim.wo.signcolumn = 'yes'
end

function C.init()

  vim.g.completion_matching_ignore_case = 1

  -- possible value: "length", "alphabet", "none"
  vim.g.completion_sorting = "length"
  vim.g.completion_matching_strategy_list = {'exact', 'substring', 'fuzzy', 'all'}

  cmd "packadd nvim-lspconfig"
  cmd "packadd completion-nvim"

  -- Stop existing clients (useful to reload after crash)
  --vim.lsp.stop_client(vim.lsp.buf_get_clients())

  require'lspconfig'.pyls.setup{on_attach = configureBuffer}
  require'lspconfig'.clangd.setup{on_attach = configureBuffer}
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
  }
end

function C.clearSigns()
  vim.api.nvim_buf_clear_namespace(0, -1, 0, -1)
  cmd "sign unplace * group=*"
end

return C
