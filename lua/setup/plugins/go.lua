return function()
	return require("go").setup({
		goimport = "goimports",
		comment_placeholder = "",
		fillstruct = "fillstruct",
		gocoverage_sign = "█",
		lsp_cfg = {
			settings = {
				gopls = {
					gofumpt = true,
					codelenses = {
						gc_details = false,
						generate = true,
						regenerate_cgo = true,
						run_govulncheck = true,
						test = true,
						tidy = true,
						upgrade_dependency = true,
						vendor = true,
					},
					hints = {
						assignVariableTypes = true,
						compositeLiteralFields = true,
						compositeLiteralTypes = true,
						constantValues = true,
						functionTypeParameters = true,
						parameterNames = true,
						rangeVariableTypes = true,
					},
					analyses = {
						fieldalignment = true,
						nilness = true,
						unusedparams = true,
						unusedwrite = true,
						useany = true,
					},
					usePlaceholders = true,
					completeUnimported = true,
					staticcheck = true,
					directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
					semanticTokens = true,
				},
			},
		},
		lsp_document_formatting = false,
		lsp_inlay_hints = { enable = false },
		luasnip = true,
		gopls_remote_auto = false,
		lsp_diag_update_in_insert = false,
		lsp_keymaps = false,
		dap_debug = false,
		trouble = true,
	})
end
