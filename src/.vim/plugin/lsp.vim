if exists("g:loaded_plugin_lsp")
  finish
endif
let g:loaded_plugin_lsp = 1

packadd nvim-lspconfig
packadd completion-nvim

lua << EOF
require'nvim_lsp'.pyls.setup{}
require'nvim_lsp'.clangd.setup{}
EOF

" use omni completion provided by lsp
augroup lsp
  au!
  autocmd Filetype python setlocal omnifunc=v:lua.vim.lsp.omnifunc
  " Use completion-nvim in every buffer
  autocmd BufEnter * lua require'completion'.on_attach()
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

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

let g:completion_matching_ignore_case = 1
" possible value: "length", "alphabet", "none"
let g:completion_sorting = "length"
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy', 'all']
