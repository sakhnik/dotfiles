return {
  plugins = {
    'ellisonleao/gruvbox.nvim';
    'jnurmine/zenburn';
    'mhartington/oceanic-next';
    'savq/melange';
  },

  setup = function()
    -- Just load the module to ensure the plugin has been installed
    require'gruvbox'

    -- Configure colorscheme
    local augid = vim.api.nvim_create_augroup('colors', {clear = true})
    vim.api.nvim_create_autocmd('ColorScheme', {
      group = augid,
      pattern = "*",
      command = "hi Comment cterm=italic gui=italic",
    })
    vim.o.background = 'light'
    vim.api.nvim_command 'colors gruvbox'
  end
}
