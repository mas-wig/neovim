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
				lsp_on_attach = require("plugins.lsp.utils"),
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

	{
		"jose-elias-alvarez/typescript.nvim",
		ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
		config = function()
			return require("typescript").setup({
				disable_commands = false,
				debug = false,
				go_to_source_definition = {
					fallback = true,
				},
				server = {
					on_attach = require("plugins.lsp.utils"),
					completions = { completeFunctionCalls = true },
					-- 	javascript = {
					-- 		inlayHints = {
					-- 			includeInlayEnumMemberValueHints = true,
					-- 			includeInlayFunctionLikeReturnTypeHints = true,
					-- 			includeInlayFunctionParameterTypeHints = true,
					-- 			includeInlayParameterNameHints = "all", -- none | literals | all
					-- 			includeInlayParameterNameHintsWhenArgumentMatchesName = true,
					-- 			includeInlayPropertyDeclarationTypeHints = true,
					-- 			includeInlayVariableTypeHints = true,
					-- 			includeInlayVariableTypeHintsWhenTypeMatchesName = true,
					-- 		},
					-- 	},
					-- 	typescript = {
					-- 		inlayHints = {
					-- 			includeInlayEnumMemberValueHints = true,
					-- 			includeInlayFunctionLikeReturnTypeHints = true,
					-- 			includeInlayFunctionParameterTypeHints = true,
					-- 			includeInlayParameterNameHints = "all", -- none | literals | all
					-- 			includeInlayParameterNameHintsWhenArgumentMatchesName = true,
					-- 			includeInlayPropertyDeclarationTypeHints = true,
					-- 			includeInlayVariableTypeHints = true,
					-- 			includeInlayVariableTypeHintsWhenTypeMatchesName = true,
					-- 		},
					-- 	},
				},
			})
		end,
	},

	{
		"simrat39/rust-tools.nvim",
		ft = { "rust" },
		config = function()
			local on_attach = require("plugins.lsp.utils")
			return require("rust-tools").setup({
				on_attach = on_attach,
				inlay_hints = { auto = false },
				hover_actions = { border = "rounded" },
			})
		end,
	},
}
