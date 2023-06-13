return {
	init = function()
		require("legendary").keymaps({
			{
				itemgroup = "Golang Key",
				description = "Write me Daddy",
				icon = "🚀 ",
				keymaps = {
					{
						"<leader>Gi",
						function()
							vim.ui.input({ prompt = "GoImpl 'reciver' 'interface'" }, function(name)
								if name ~= nil then
									vim.cmd("GoImpl " .. name)
								end
							end)
						end,
						desc = "GoImpl ",
					},
				},
			},
		})
	end,
	setup = function()
		local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
		return require("go").setup({
			goimport = "goimports",
			fillstruct = "fillstruct",
			gocoverage_sign = "█",
			lsp_cfg = {
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					require("setup.plugins.lsp").mappings(client, bufnr)
				end,
			},
			lsp_document_formatting = true,
			lsp_inlay_hints = { enable = false },
			luasnip = true,
			lsp_diag_update_in_insert = false,
			lsp_keymaps = false,
			dap_debug = false,
		})
	end,
}
