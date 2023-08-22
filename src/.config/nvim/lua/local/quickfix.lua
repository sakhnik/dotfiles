return {
  plugins = {
    {url = 'https://gitlab.com/yorickpeterse/nvim-pqf'};
  },

  setup = function()
    require'pqf'.setup()
  end
}
