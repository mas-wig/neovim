return {
	lua_ls = {
		filetypes = { "lua" },
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
			completion = { callSnippet = "Replace" },
		},
	},
	tsserver = {
		init_options = { hostInfo = "neovim" },
		root_dir = function()
			return os.getenv("PWD")
		end,
		single_file_support = true,
	},
}
