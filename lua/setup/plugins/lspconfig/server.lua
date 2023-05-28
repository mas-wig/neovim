return {
	lua_ls = {
		filetypes = { "lua" },
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
			completion = { callSnippet = "Replace" },
		},
	},
	html = {
		filetypes = { "html" },
		root_dir = function(fname)
			return require("lspconfig").util.root_pattern(".git")(fname) or require("setup.utils").dirname(fname)
		end,
		init_options = {
			configurationSection = { "html", "css", "javascript" },
			embeddedLanguages = {
				css = true,
				javascript = true,
			},
			provideFormatter = true,
		},
		single_file_support = true,
	},

	cssls = {
		filetypes = { "css", "scss", "less" },
		single_file_support = true,
		root_dir = function(fname)
			return require("lspconfig").util.root_pattern(".git")(fname) or require("setup.utils").dirname(fname)
		end,
		settings = {
			css = {
				validate = true,
			},
			less = {
				validate = true,
			},
			scss = {
				validate = true,
			},
		},
	},
}
