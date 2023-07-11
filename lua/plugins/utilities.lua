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
	{
		"m4xshen/hardtime.nvim",
		event = "VeryLazy",
		opts = {
			max_time = 5,
			max_count = 2,
			disable_mouse = false,
			hint = true,
			allow_different_key = false,
		},
	},
}
