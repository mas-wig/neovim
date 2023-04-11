return {
	{
		"ray-x/go.nvim",
		branch = "master",
		ft = { "go" },
		build = ":GoInstallBinaries",
		dependencies = {
			"ray-x/guihua.lua",
			branch = "master",
			build = "cd lua/fzy && make",
			lazy = true,
		},
		config = function()
			local capabilities =
				require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
			return require("go").setup({
				goimport = "goimports",
				lsp_on_attach = function()
					require("setup.utils").on_attach(function(client, _)
						client.server_capabilities.documentFormattingProvider = true
						client.server_capabilities.documentRangeFormattingProvider = true
					end)
				end,
				lsp_cfg = {
					capabilities = capabilities,
				},
				lsp_document_formatting = true,
				lsp_inlay_hints = {
					enable = false,
				},
				luasnip = true,
				lsp_diag_update_in_insert = true,
				lsp_keymaps = false,
				dap_debug = false,
			})
		end,
	},
	-- █████╗ █████╗ █████╗ █████╗ █████╗ █████╗
	-- ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝
	{
		"jose-elias-alvarez/typescript.nvim",
		ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
		config = function()
			local on_attach = require("setup.utils").on_attach(function(client, bufnr)
				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({
						group = vim.api.nvim_create_augroup("LspFormatting", {}),
						buffer = bufnr,
					})
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = vim.api.nvim_create_augroup("LspFormatting", {}),
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({
								filter = function(client)
									return client.name == "null-ls"
								end,
								bufnr = bufnr,
								id = client.id,
								timeout_ms = 5000,
								async = true,
							})
						end,
					})
				end
				client.server_capabilities.documentFormattingProvider = true
				client.server_capabilities.documentRangeFormattingProvider = true
			end)
			return require("typescript").setup({
				disable_commands = false,
				debug = false,
				go_to_source_definition = {
					fallback = true,
				},
				server = {
					on_attach = on_attach,
				},
			})
		end,
	},
	-- █████╗ █████╗ █████╗ █████╗ █████╗ █████╗
	-- ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝
	{
		"simrat39/rust-tools.nvim",
		ft = { "rust" },
		config = function()
			local on_attach = require("setup.utils").on_attach(function(client, _)
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false
			end)
			return require("rust-tools").setup({
				on_attach = on_attach,
				inlay_hints = { auto = false },
				hover_actions = { border = "rounded" },
			})
		end,
	},
}
