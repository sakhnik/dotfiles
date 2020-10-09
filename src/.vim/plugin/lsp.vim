if exists("g:loaded_plugin_lsp")
  finish
endif
let g:loaded_plugin_lsp = 1

packadd nvim-lspconfig

lua << EOF
require'nvim_lsp'.pyls.setup{}
require'nvim_lsp'.clangd.setup{}
EOF

" use omni completion provided by lsp
augroup lsp
  au!
  autocmd Filetype python setlocal omnifunc=v:lua.vim.lsp.omnifunc
augroup END

nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
