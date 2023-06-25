return function()
	return require("go").setup({
		goimport = "goimports",
		fillstruct = "fillstruct",
		gocoverage_sign = "█",
		lsp_cfg = false,
		lsp_document_formatting = true,
		lsp_inlay_hints = { enable = false },
		luasnip = true,
		lsp_diag_update_in_insert = false,
		lsp_keymaps = false,
		dap_debug = false,
	})
end
