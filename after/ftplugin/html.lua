vim.opt_local.matchpairs:append("<:>")

vim.cmd("augroup LspHighlight")
vim.cmd("autocmd!")
vim.cmd("autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()")
vim.cmd("autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()")
vim.cmd("augroup END")
