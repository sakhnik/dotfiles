local C = {}

local paq = require'paq-nvim'.paq  -- Import module and bind `paq` function

paq {'nvim-lua/popup.nvim'}
paq {'nvim-lua/plenary.nvim'}
paq {'nvim-telescope/telescope.nvim'}
paq {'nvim-telescope/telescope-project.nvim'}

function C.setup()
  local keymap = vim.api.nvim_set_keymap

  local noremap_silent = {noremap = true, silent = true}
  keymap('n', '<leader>ff', ':Telescope find_files<cr>', noremap_silent)
  keymap('n', '<leader>fg', ':Telescope git_files<cr>', noremap_silent)
  keymap('n', '<leader>f<space>', ':Telescope builtin<cr>', noremap_silent)
  keymap('n', '<leader>gg', ':Telescope live_grep<cr>', noremap_silent)
  keymap('n', '<leader>fc', ':Telescope current_buffer_fuzzy_find<cr>', noremap_silent)
  keymap('n', '<leader>fh', ':Telescope command_history<cr>', noremap_silent)
  keymap('n', '<leader>fp', ":lua require'telescope'.extensions.project.project{}<CR>", noremap_silent)

  require'telescope'.setup{
    defaults = {
      path_display = {shorten = 4, 'truncate'},
      file_ignore_patterns = {'%.class'},
    },
  }
end

return C
