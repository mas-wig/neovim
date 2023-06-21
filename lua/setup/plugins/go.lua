return function()
	local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
	return require("go").setup({
		goimport = "goimports",
		fillstruct = "fillstruct",
		gocoverage_sign = "█",
		lsp_cfg = {
			capabilities = capabilities,
		},
		lsp_document_formatting = true,
		lsp_inlay_hints = { enable = false },
		luasnip = true,
		lsp_diag_update_in_insert = false,
		lsp_keymaps = false,
		dap_debug = false,
	})
end
