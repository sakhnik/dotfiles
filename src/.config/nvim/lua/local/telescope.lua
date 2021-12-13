local C = {}

require 'paq' {
  'nvim-lua/popup.nvim';
  'nvim-lua/plenary.nvim';
  'nvim-telescope/telescope.nvim';
  'nvim-telescope/telescope-project.nvim';
}

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
    pickers = {
      find_files = {
        no_ignore = true,
      },
    },
  }
end

return C
