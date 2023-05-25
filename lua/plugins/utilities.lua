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
		config = function()
			require("setup.plugins.resession").setup()
		end,
		init = function()
			require("setup.plugins.resession").init()
		end,
	},

	-- {
	-- 	"m4xshen/hardtime.nvim",
	-- 	event = { "BufRead", "BufNewFile" },
	-- 	opts = {
	-- 		max_time = 50,
	-- 		max_count = 4,
	-- 		disable_mouse = true,
	-- 		hint = true,
	-- 		allow_different_key = false,
	-- 		resetting_keys = { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "c", "d", "x", "X", "p", "P" },
	-- 		restricted_keys = { "h", "j", "k", "l", "-", "+", "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>" },
	-- 		hint_keys = { "k", "j", "^", "$", "a", "i", "d", "y", "c", "l" },
	-- 		disabled_keys = { "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>" },
	-- 		disabled_filetypes = { "qf", "netrw", "NvimTree", "lazy", "mason" },
	-- 	},
	-- },

	{
		"cbochs/grapple.nvim",
		event = { "BufRead", "BufNewFile" },
		init = function()
			require("setup.plugins.graple").init()
		end,
		config = function()
			require("setup.plugins.graple").setup()
		end,
	},
}
