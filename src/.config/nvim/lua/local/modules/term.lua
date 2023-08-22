return {
  plugins = {
    'numToStr/FTerm.nvim';
  },

  setup = function()
    local function get_shell()
      if vim.fn.has('win32') == 1 then
        return "powershell"
      end
      return os.getenv('SHELL')
    end

    require'FTerm'.setup({
        cmd = get_shell(),
    })

    -- Example keybindings
    vim.keymap.set('n', '<A-i>', function() require("FTerm").toggle() end, {})
    vim.keymap.set('t', '<A-i>', function()
      vim.api.nvim_input('<C-\\><C-n>')
      require("FTerm").toggle()
    end, {})
  end
}
