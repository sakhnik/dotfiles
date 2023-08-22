return {
  plugins = {
    'tpope/vim-fugitive';
    'tpope/vim-eunuch';               -- :SudoWrite
    'tpope/vim-repeat';               -- Repeat mapping with .
    'tpope/vim-sleuth';               -- Set buffer options euristically
    'tpope/vim-unimpaired';           -- ]q, ]a etc
    'kylechui/nvim-surround';         -- Movements s', s(
    'bronson/vim-visual-star-search';
    'raimondi/delimitmate';
    'wellle/targets.vim';
    'sheerun/vim-polyglot';
    'mh21/errormarker.vim';
    'sirtaj/vim-openscad';
    'plasticboy/vim-markdown';
    'andymass/vim-matchup';
    'majutsushi/tagbar';
    'Kris2k/A.vim';
    'ledger/vim-ledger';
  },
  setup = function()
    require'nvim-surround'.setup()
    require'local/ledger'.setup()
    vim.g.polyglot_disabled = {'sensible'}
  end
}
