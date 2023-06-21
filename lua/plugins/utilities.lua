return {
	{ "nvim-lua/plenary.nvim", lazy = true },

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			require("setup.plugins.whichkey")()
		end,
	},
	{
		"akinsho/toggleterm.nvim",
		cmd = { "ToggleTerm", "TermExec", "TermSelect", "ToggleTermToggleAll" },
		keys = require("setup.plugins.toggleterm").keys,
		config = function()
			require("setup.plugins.toggleterm").setup()
		end,
	},

	{
		"m4xshen/hardtime.nvim",
		enabled = false,
		event = { "BufRead", "BufNewFile" },
		opts = {
			max_time = 10,
			max_count = 4,
			disable_mouse = true,
			hint = true,
			allow_different_key = false,
			resetting_keys = { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "c", "d", "x", "X", "p", "P" },
			restricted_keys = { "h", "j", "k", "l", "-", "+", "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>" },
			hint_keys = { "k", "j", "^", "$", "a", "i", "d", "y", "c", "l" },
			disabled_keys = { "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>" },
			disabled_filetypes = { "qf", "netrw", "NvimTree", "lazy", "mason" },
		},
	},

	{
		"cbochs/grapple.nvim",
		event = { "BufRead", "BufNewFile" },
		keys = require("setup.plugins.graple").keys,
		config = function()
			require("setup.plugins.graple").setup()
		end,
	},
	{
		"stevearc/resession.nvim",
		enabled = true,
		config = function()
			require("setup.plugins.resession")()
		end,
	},
}
