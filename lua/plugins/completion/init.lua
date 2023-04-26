return {
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{ "hrsh7th/cmp-buffer", lazy = true },
			{ "hrsh7th/cmp-path", lazy = true },
			{ "hrsh7th/cmp-cmdline", lazy = true },
			{ "saadparwaiz1/cmp_luasnip", lazy = true },
			{ "tzachar/cmp-fuzzy-buffer", dependencies = { "tzachar/fuzzy.nvim" }, lazy = true },
			{ "hrsh7th/cmp-nvim-lsp", lazy = true },
			{ "dmitmel/cmp-cmdline-history", lazy = true },
		},
		config = function()
			require("plugins.completion.nvim-cmp")()
		end,
	},
	{
		"L3MON4D3/LuaSnip",
		event = "InsertEnter",
		build = (not jit.os:find("Windows"))
				and "echo -e 'NOTE: jsregexp is optional, so not a big deal if it fails to build\n'; make install_jsregexp"
			or nil,
		dependencies = { "rafamadriz/friendly-snippets", lazy = true },
		config = function()
			require("plugins.completion.luasnippet")()
		end,
	},
}
