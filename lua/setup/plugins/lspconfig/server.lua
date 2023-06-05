return {
	lua_ls = {
		filetypes = { "lua" },
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
			completion = { callSnippet = "Replace" },
		},
	},
}
