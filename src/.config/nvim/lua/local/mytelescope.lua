local C = {}

function C.setup()
  local noremap_silent = {noremap = true, silent = true}
  local tsbi = require('telescope.builtin')
  vim.keymap.set('n', '<leader>ff', tsbi.find_files, noremap_silent)
  vim.keymap.set('n', '<leader>fg', tsbi.git_files, noremap_silent)
  vim.keymap.set('n', '<leader>f<space>', tsbi.builtin, noremap_silent)
  vim.keymap.set('n', '<leader>gg', tsbi.live_grep, noremap_silent)
  vim.keymap.set('n', '<leader>fc', tsbi.current_buffer_fuzzy_find, noremap_silent)
  vim.keymap.set('n', '<leader>fh', tsbi.command_history, noremap_silent)
  vim.keymap.set('n', '<leader>fp', function() require'telescope'.extensions.project.project{} end, noremap_silent)

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
