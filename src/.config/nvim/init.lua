-- vim: set et ts=2 sw=2:
--

-- disable netrw in favour of nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local cmd = vim.api.nvim_command

vim.o.fileencodings = 'utf-8,cp1251,default'
vim.o.wildmode = 'longest,list,full'
vim.o.diffopt = vim.o.diffopt .. ',iwhite'
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.tabstop = 4
vim.o.cindent = true
vim.o.shiftwidth = 4
vim.o.cinoptions = ":0,=1s,g0,M1,U0,u0,N-s"
vim.o.copyindent = true
vim.o.expandtab = true
vim.o.hidden = false
vim.o.autowrite = true
vim.o.mouse = 'a'
vim.o.termguicolors = true
vim.o.completeopt = 'menu,preview'
vim.o.shortmess = 'ac'
if vim.fn.has('win32') == 1 then
  -- 'shellslash' may be necessary for lsp to detect workspace directories
  -- (for lua specifically)
  vim.o.shellslash = false
end

cmd [[let mapleader = ' ']]
cmd [[let maplocalleader = ' ']]

vim.o.lazyredraw = true
vim.o.laststatus = 2

vim.o.showbreak = '\\'  --↪
vim.o.undofile = true

-- Forget about ex mode
vim.keymap.set('', 'Q', function() end, {})

-- Find tailing white spaces
vim.keymap.set('n', '<Leader><space>', [[/\s\+$\| \+\ze\t<cr>]], {noremap = true})

-- NetRW
vim.g.netrw_liststyle = 3

-- Do the rest asynchronously because plugins may be required
local function async_part()
  require'local.plugins'()
  require'local.digraphs'
  require'local.autocmds'

  -- Configure colorscheme zenburn
  local augid = vim.api.nvim_create_augroup('colors', {clear = true})
  vim.api.nvim_create_autocmd('ColorScheme', {
    group = augid,
    pattern = "*",
    command = "hi Comment cterm=italic gui=italic",
  })
  vim.o.background = 'light'
  cmd 'colors gruvbox'

  -- Initialize nvim-lsp. Not calling this will allow using YouCompleteMe,
  -- for example.
  vim.keymap.set('n', '<leader>ll', function() require"local.lsp".setup() end, {})
  vim.keymap.set('n', '<leader>lc', function() require"local.lsp".clearSigns() end, {})
end

local co = coroutine.create(function()
  local ok, res = pcall(async_part)
  if not ok then
    error(res)
  end
end)
coroutine.resume(co)
