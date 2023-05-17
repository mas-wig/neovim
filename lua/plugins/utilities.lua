return {
	{ "nvim-lua/plenary.nvim", lazy = true },

	{
		"mrjones2014/legendary.nvim",
		lazy = false,
		branch = "master",
		priority = 900,
		dependencies = { "kkharji/sqlite.lua" },
		init = function()
			require("legendary").keymaps({
				{
					"<leader>lg",
					require("legendary").find,
					hide = true,
					description = "Open Legendary",
					mode = { "n", "v" },
				},
			})
		end,
		config = function()
			require("legendary").setup({
				select_prompt = "Legendary",
				include_builtin = false,
				include_legendary_cmds = false,
				which_key = { auto_register = false },
				autocmds = require("core.autocmds"),
			})
		end,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			require("setup.plugins.whichkey")()
		end,
	},
	{
		"akinsho/toggleterm.nvim",
		lazy = true,
		cmd = "ToggleTerm",
		init = function()
			require("setup.plugins.toggleterm").init()
		end,
		config = function()
			require("setup.plugins.toggleterm").setup()
		end,
	},

	{
		"stevearc/resession.nvim",
		priority = 100,
		opts = function()
			local function is_valid(bufnr)
				if not bufnr or bufnr < 1 then
					return false
				end
				return vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted
			end
			return {
				buf_filter = function(bufnr)
					return is_valid(bufnr)
				end,
				tab_buf_filter = function(tabpage, bufnr)
					return vim.tbl_contains(vim.t[tabpage].bufs, bufnr)
				end,
				extensions = { bodrex = {} },
			}
		end,
	},
}
