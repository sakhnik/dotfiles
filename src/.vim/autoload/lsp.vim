function! lsp#EnableLocal()

  packadd nvim-lspconfig
  packadd completion-nvim

  lua << EOF
require'lspconfig'.pyls.setup{}
require'lspconfig'.clangd.setup{}
EOF

  setlocal omnifunc=v:lua.vim.lsp.omnifunc

  nnoremap <silent><buffer> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
  nnoremap <silent><buffer> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
  nnoremap <silent><buffer> K     <cmd>lua vim.lsp.buf.hover()<CR>
  nnoremap <silent><buffer> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
  nnoremap <silent><buffer> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
  nnoremap <silent><buffer> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
  nnoremap <silent><buffer> gr    <cmd>lua vim.lsp.buf.references()<CR>
  nnoremap <silent><buffer> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
  nnoremap <silent><buffer> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>

  " Use completion-nvim in every buffer
  lua require'completion'.on_attach()

  " Use <Tab> and <S-Tab> to navigate through popup menu
  inoremap <expr><buffer> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
  inoremap <expr><buffer> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

  " Set completeopt to have a better completion experience
  setlocal completeopt=menuone,noinsert,noselect

  " Avoid showing message extra message when using completion
  setlocal shortmess+=c

  let g:completion_matching_ignore_case = 1
  " possible value: "length", "alphabet", "none"
  let g:completion_sorting = "length"
  let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy', 'all']

endfunction
