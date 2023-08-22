return {
  plugins = {
    'nvim-tree/nvim-tree.lua';
    'nvim-tree/nvim-web-devicons';
    'stevearc/oil.nvim';
  },

  setup = function()
    require("nvim-tree").setup()
    vim.keymap.set('n', '<leader>nn', function() require("nvim-tree.api").tree.toggle() end, {})

    require("oil").setup()
    vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })
  end
}
