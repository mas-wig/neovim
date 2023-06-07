return {
	{
		"ray-x/go.nvim",
		branch = "master",
		ft = { "go", "gomod" },
		build = ":GoInstallBinaries",
		dependencies = {
			"ray-x/guihua.lua",
			branch = "master",
			build = "cd lua/fzy && make",
			lazy = true,
		},
		config = function()
			require("setup.plugins.go").init()
			require("setup.plugins.go").setup()
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
					on_attach = require("setup.plugins.lspconfig").setup(),
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
}
