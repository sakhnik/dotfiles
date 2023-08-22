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

    vim.g.ledger_bin = 'ledger'
    vim.g.ledger_date_format = '%Y-%m-%d'
    vim.g.ledger_extra_options = '--pedantic --explicit --price-db prices.db --date-format ' .. vim.g.ledger_date_format
    vim.g.ledger_align_at = 45
    vim.g.ledger_default_commodity = '₴'
    vim.g.ledger_commodity_before = 0
    vim.g.ledger_commodity_sep = ' '
    vim.g.ledger_fold_blanks = 1

    vim.g.polyglot_disabled = {'sensible'}
  end
}
