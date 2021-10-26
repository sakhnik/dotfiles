local C = {}

function C.setup()
  vim.g.ledger_bin = 'ledger'
  vim.g.ledger_date_format = '%Y-%m-%d'
  vim.g.ledger_extra_options = '--pedantic --explicit --price-db prices.db --date-format ' .. vim.g.ledger_date_format
  vim.g.ledger_align_at = 45
  vim.g.ledger_default_commodity = '₴'
  vim.g.ledger_commodity_before = 0
  vim.g.ledger_commodity_sep = ' '
  vim.g.ledger_fold_blanks = 1
end

return C
