return {
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{ "hrsh7th/cmp-buffer", lazy = true },
			{ "lukas-reineke/cmp-rg", lazy = true },
			{ "hrsh7th/cmp-path", lazy = true },
			{ "hrsh7th/cmp-cmdline", lazy = true },
			{ "saadparwaiz1/cmp_luasnip", lazy = true },
			{ "tzachar/cmp-fuzzy-buffer", dependencies = { "tzachar/fuzzy.nvim" }, lazy = true },
			{ "hrsh7th/cmp-nvim-lsp", lazy = true },
			{ "dmitmel/cmp-cmdline-history", lazy = true },
		},
		config = function()
			require("setup.plugins.nvim-cmp")()
		end,
	},
	{
		"L3MON4D3/LuaSnip",
		event = "InsertEnter",
		build = (not jit.os:find("Windows"))
				and "echo -e 'NOTE: jsregexp is optional, so not a big deal if it fails to build\n'; make install_jsregexp"
			or nil,
		dependencies = {
			"rafamadriz/friendly-snippets",
			config = function()
				require("luasnip.loaders.from_vscode").lazy_load()
			end,
		},
		opts = {
			history = true,
			delete_check_events = "TextChanged",
		},
		config = function()
			vim.api.nvim_create_autocmd("InsertLeave", {
				callback = function()
					if
						require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
						and not require("luasnip").session.jump_active
					then
						require("luasnip").unlink_current()
					end
				end,
			})
		end,
	},
}
