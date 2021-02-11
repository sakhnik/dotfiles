local C = {}

local function configureBuffer()
  vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

  local buf = vim.api.nvim_get_current_buf()
  local opts = {noremap = true, silent = true}
  vim.api.nvim_buf_set_keymap(buf, 'n', 'gd', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(buf, 'n', '<c-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(buf, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(buf, 'n', 'gD', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(buf, 'n', '<c-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(buf, 'n', '1gD', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(buf, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(buf, 'n', 'g0', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
  vim.api.nvim_buf_set_keymap(buf, 'n', 'gW', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)

  -- Use completion-nvim in this buffer
  require'completion'.on_attach()

  -- Use <Tab> and <S-Tab> to navigate through popup menu
  opts = {noremap = true, silent = true, expr = true}
  vim.api.nvim_buf_set_keymap(buf, 'i', '<Tab>', [[pumvisible() ? "\<C-n>" : "\<Tab>"]], opts)
  vim.api.nvim_buf_set_keymap(buf, 'i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], opts)

  -- Set completeopt to have a better completion experience
  vim.cmd("setlocal completeopt=menuone,noinsert,noselect")

  -- Avoid showing message extra message when using completion
  vim.cmd("setlocal shortmess+=c")
  vim.wo.signcolumn = 'yes'
end

function C.init()

  vim.cmd("packadd nvim-lspconfig")
  vim.cmd("packadd completion-nvim")

  -- Stop existing clients (useful to reload after crash)
  --vim.lsp.stop_client(vim.lsp.buf_get_clients())

  require'lspconfig'.pyls.setup{on_attach = configureBuffer}
  require'lspconfig'.clangd.setup{on_attach = configureBuffer}

  vim.g.completion_matching_ignore_case = 1

  -- possible value: "length", "alphabet", "none"
  vim.g.completion_sorting = "length"
  vim.g.completion_matching_strategy_list = {'exact', 'substring', 'fuzzy', 'all'}
end

function C.clearSigns()
  vim.api.nvim_buf_clear_namespace(0, -1, 0, -1)
  vim.cmd("sign unplace * group=*")
end

return C
